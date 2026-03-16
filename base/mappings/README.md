# Mappings

`mappings/` описывает, как сущности из общей модели раскладываются по платформам.

Здесь должна лежать логика уровня:

- `instruction` -> `AGENTS.md`
- `instruction` -> `CLAUDE.md`
- `instruction` -> `.cursor/rules/*.mdc`
- `agent` -> provider-specific agent file or section
- `skill` -> provider-specific skill layout

## Что важно фиксировать

- какие типы сущностей поддерживает каждая платформа;
- в какие файлы они попадают;
- какие поля обязательны;
- какие поля теряются при переносе;
- какие случаи требуют исключения или ручной доработки.
