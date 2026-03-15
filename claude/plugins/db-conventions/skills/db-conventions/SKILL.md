# PostgreSQL Database Conventions

Общие конвенции для всех Kaiten-проектов (kaiten-lib, kaiten-billing и др.).
Применяй эти правила при работе с PostgreSQL: создание таблиц, миграции, индексы, запросы.

---

## 1. Идентификаторы

- **Новые таблицы и ключи — UUID v4:**
  ```sql
  id uuid primary key default uuid_generate_v4()
  ```
- **Legacy-таблицы** могут использовать `serial` / `int` — не ломай существующие.
- Сортировку обеспечивай через `created` / `created_at` или явный `sort_order`, а не по UUID.

---

## 2. Именование

### Таблицы
- `snake_case`, **единственное число** для сущностей: `board`, `user`, `work_calendar`.
- **Множественное число** для M2M join-таблиц: `user_companies`, `card_users`, `tariff_project_scopes`.

### Внешние ключи (FK-именование)
Суффикс FK-колонки определяется **целевым полем** таблицы, на которое ссылаемся:

| Ссылка на | Тип | Имя FK-колонки | Пример |
|-----------|-----|----------------|--------|
| `table.id` (int) | int | `table_id` | `user_id int references "user"(id)` |
| `table.id` (uuid) | uuid | `table_id` | `project_id uuid references project(id)` |
| `table.uid` (uuid) | uuid | `table_uid` | `user_uid uuid references "user"(uid)` |

**Антипаттерн:** `author_id uuid references "user"(uid)` — название `_id` не соответствует целевому полю `uid`.

### Индексы
- Формат: `<table>__<cols>_idx` (двойное подчёркивание перед списком колонок):
  ```sql
  create index card_history__lane_id_idx on card_history (lane_id);
  create unique index tag__company_id_name_idx on tag(company_id, lower(name));
  ```

### Enum-типы
- Формат: `<domain>_<column_name>`:
  ```sql
  create type schema_state as enum ('done', 'in_progress', 'error');
  create type token_transaction_type as enum ('purchase', 'usage', 'refund');
  ```

### Check-ограничения
- Формат: `constraint <table>_<short_desc>_check`:
  ```sql
  constraint card_sort_order_check check (sort_order <> 'Infinity' and sort_order <> 'NaN');
  ```

---

## 3. Стратегия индексирования

### BTREE (default)
Primary keys, FK, колонки фильтрации/сортировки:
```sql
create index if not exists tag__company_id_idx on tag(company_id);
```

### UNIQUE
Бизнес-уникальность со scope:
```sql
create unique index tag__company_id_name_idx on tag(company_id, lower(name));
create unique index company_auth_methods_local_company_id_idx
  on company_auth_strategy(company_id, strategy)
  where strategy = 'local';
```

### PARTIAL
Уменьшают размер индекса, ускоряют частые фильтры:
```sql
create index column__autoarchivation_idx on "column"(id)
  where ("type" in (1,3) and archive_after_days > -1);
```

### GIN + Trigram (pg_trgm)
Для fuzzy/ILIKE текстового поиска:
```sql
create index group__company_id_name_idx
  on "group" using gin (company_id, lower(name) gin_trgm_ops)
  with (fastupdate = on);
```

### INCLUDE (covering)
Покрывающие индексы — дополнительные поля без участия в предикате:
```sql
create index card__board_id_idx on card(board_id) include(id);
```

---

## 4. Foreign Keys & ON DELETE

Выбирай семантику осознанно:

| Стратегия | Когда использовать | Пример |
|-----------|-------------------|--------|
| `cascade` | Жёсткая связь — дочерние строки удаляются с родителем | `card_id int not null references "card" on delete cascade` |
| `restrict` | Защита от удаления при наличии зависимых данных | `author_id int not null references "user" on delete restrict` |
| `set null` | Опциональная ссылка | `foreign key (space_uid) references space(uid) on delete set null` |

Составные FK:
```sql
foreign key (entity_uid, user_id)
  references tree_entity_users(entity_uid, user_id) on delete cascade;
```

---

## 5. Constraints

- Предпочитай **DB-constraints** (`check`, `not null`, `unique`, `foreign key`) вместо валидации в app-логике.
- Примеры:
  ```sql
  constraint migration__status_check check (
    (status = 'queued' and pid is null and not running)
    or (status = 'in_progress' and pid is not null)
    or (status = 'error' and not running)
    or (status = 'done' and not running)
  );

  check (period_start < period_finish);
  check ((period_start >= 0) and (period_start < 1440));
  ```

---

## 6. Наследование базовых таблиц (audit fields)

| Базовая таблица | Колонки | Назначение |
|----------------|---------|------------|
| `_created` | `created` / `created_at` timestamptz | Время создания |
| `_updated` | `updated` / `updated_at` timestamptz | Время обновления |
| `_timestampable` | created + updated | Стандартная пара |
| `_archivable` | `archived` boolean | Soft-delete |

> **Разница между проектами:** kaiten-lib использует `created` / `updated`, kaiten-billing использует `created_at` / `updated_at`. Следуй конвенции конкретного проекта.

Пример:
```sql
create table if not exists project (
  id uuid primary key default uuid_generate_v4(),
  name varchar not null
) inherits (_timestampable);
```

---

## 7. Нормализация vs JSONB

### Нормализуй:
- Бизнес-ключи, связи, статусы — всё, что используется для **фильтрации/JOIN/уникальности**.

### JSONB допустим для:
- Редко изменяемых настроек, расширяемых атрибутов, вспомогательных логов.

### Правила JSONB:
- **Не** помещай часто фильтруемые/JOIN-ные поля в JSONB — выделяй колонки и **индексируй**.
- При обновлении **merge и clean** `null`/`undefined` чтобы избежать bloat.

---

## 8. Enum-типы

Создавай через миграции, расширяй через `alter type`:
```sql
create type card_source as enum ('import', 'api', 'manual');
alter type card_source add value if not exists 'webhook';
```

---

## 9. SQL-конвенции

### Никогда SELECT *
Всегда указывай явные колонки. Если индекс покрывает все запрошенные поля, heap может не читаться:
```sql
-- Правильно:
select id, name, email from "user" where company_id = :companyId;
-- Неправильно:
select * from "user" where company_id = :companyId;
```

### Параметризация запросов
Всегда используй параметры для защиты от SQL injection:
```js
// Knex/Bookshelf:
db.raw('select id from "column" where board_id = :boardId', { boardId });

// pg client:
client.query('select id from "column" where board_id = $1', [boardId]);
```

### TOAST
Учитывай TOAST при проектировании строк — минимизируй ненужную TOAST-активность для часто обновляемых таблиц.

### UUID вместо serial
Проекты мигрируют с `serial` на `uuid`. **Не используй `id::int`** в новых миграциях.

---

## 10. Идемпотентность

Используй `IF NOT EXISTS` / `IF EXISTS` где возможно:
```sql
create table if not exists ...;
create index if not exists ...;
create index concurrently if not exists ...;
alter table ... add column if not exists ...;
drop index if exists ...;
```

---

## 11. Soft Delete

- Предпочитай `archived` (boolean) + **partial indexes** вместо физического удаления.
- Индексируй с условием `where archived = false` для типичных запросов.
