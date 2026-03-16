# Scheduled Sync Prompt

Ниже короткий launcher prompt для агента, который запускается по расписанию.
Его задача не дублировать основной prompt, а заставить агента сначала прочитать [SYNC_AGENT_PROMPT.md](C:/git/azhukov/llm-instructions/SYNC_AGENT_PROMPT.md), а потом выполнить полный цикл синхронизации.

```text
Ты запускаешься по расписанию для репозитория `C:\git\azhukov\llm-instructions`.

Это launcher-инструкция.
Твоя первая обязательная задача: открыть и полностью прочитать файл `C:\git\azhukov\llm-instructions\SYNC_AGENT_PROMPT.md`.
Этот файл является основным рабочим prompt и содержит обязательные правила синхронизации.

Не начинай sync, пока не прочитал:
- `C:\git\azhukov\llm-instructions\SYNC_AGENT_PROMPT.md`
- `C:\git\azhukov\llm-instructions\README.md`

После чтения выполни полный sync-cycle строго по `SYNC_AGENT_PROMPT.md`.

Обязательные требования:

1. Считай синхронизацию двусторонней:
   - `base -> claude/codex/cursor`
   - `provider -> base -> all providers`

2. Не останавливайся:
   - после обновления только `base/`, если изменение переносимо в платформы;
   - после обновления только одной платформы, если изменение общее;
   - до тех пор, пока `base/`, `claude/`, `codex/` и `cursor/` не приведены к согласованному состоянию.

3. Проверь текущее состояние репозитория:
   - `git status`
   - последние изменения в `base/`, `claude/`, `codex/`, `cursor/`
   - текущее состояние `reports/`

4. Проверь актуальную официальную документацию провайдеров по реестру в:
   - `C:\git\azhukov\llm-instructions\base\docs-sources\providers.md`

5. Если изменение найдено только в одной платформе, реши:
   - это platform-specific change;
   - или это общее знание, которое надо поднять в `base/` и затем распространить на остальные платформы.

6. После принятия решений запусти локальный pipeline:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1`
   - `powershell -ExecutionPolicy Bypass -File .\scripts\validate-sync.ps1`

7. Убедись, что обновились артефакты в `reports/`.

8. В финале дай отчет:
   - source of change;
   - что было проверено в docs;
   - что обновилось в `base/`;
   - что обновилось в `claude/`, `codex/`, `cursor/`;
   - какие platform-specific exceptions остались;
   - прошли ли sync и validation.

9. Если официальный docs review невозможен из-за отсутствия доступа к сети, явно укажи это в отчете и все равно выполни локальную проверку согласованности репозитория.

10. Не коммить и не пушь изменения автоматически, если это не было отдельно указано в настройке расписания.
```

## Как использовать

Этот файл подходит для scheduler/automation как короткая входная инструкция.

Рекомендуемая схема:

1. В расписание ставится содержимое этого файла.
2. Агент стартует, читает `SCHEDULED_SYNC_PROMPT.md`.
3. Затем он открывает `SYNC_AGENT_PROMPT.md`.
4. После этого он выполняет полный sync по основному prompt.

Если нужен режим с авто-коммитом, лучше сделать отдельный variant prompt, а не включать commit/push по умолчанию в этот файл.
