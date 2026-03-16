# Cursor Sync

Эта папка описывает, как Cursor-адаптер синхронизируется с общей базой.

## Что уже есть

- source of truth в `../base/`;
- generated outputs в `../AGENTS.md` и `../rules/`;
- render pipeline в `../../scripts/sync-platforms.ps1`.

## Как запускать

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

## Что дальше можно добавить

- валидацию `.mdc` files после генерации;
- diff-отчет по rule files;
- explicit mapping для `Always` / on-demand rule strategies.
