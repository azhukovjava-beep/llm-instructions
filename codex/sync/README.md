# Codex Sync

Эта папка описывает, как Codex-адаптер синхронизируется с общей базой.

## Что уже есть

- source of truth в `../base/`;
- generated outputs в `../AGENTS.md` и `../skills/`;
- render pipeline в `../../scripts/sync-platforms.ps1`.

## Как запускать

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

## Что дальше можно добавить

- расписание запуска;
- отчет о diff между `base/` и `codex/`;
- отдельный sync-run prompt для Codex automation.
