# Cursor

Папка для Cursor-специфичной адаптации общей базы.

## Что здесь уже есть

- `AGENTS.md` - fallback-инструкция для root-level сценариев.
- `rules/` - сгенерированные `.mdc` rules из `base/`.
- `sync/` - заметки по синхронизации и ограничениям переноса.

## Источник правды

- Общий смысл живет в `../base/`.
- Основной Cursor-адаптер здесь - это `rules/`.
- Если изменение общее, сначала обновляется `base/`, потом запускается sync.

## Как обновлять

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

## Runtime target

При экспорте в реальный проект:

- `cursor/AGENTS.md` -> `AGENTS.md` при простом root-level режиме
- `cursor/rules/*.mdc` -> `.cursor/rules/*.mdc`
