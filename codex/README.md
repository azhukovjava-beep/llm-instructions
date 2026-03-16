# Codex

Папка для Codex-специфичной адаптации общей базы.

## Что здесь уже есть

- `AGENTS.md` - сгенерированный основной файл инструкций для Codex.
- `skills/` - сгенерированные shared skills из `base/`.
- `sync/` - заметки по автоматизации и процессу синхронизации.

## Источник правды

- Общий смысл живет в `../base/`.
- Файлы в `codex/` считаются adapter outputs.
- Если изменение общее, сначала обновляется `base/`, потом запускается sync.

## Как обновлять

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

## Runtime target

При экспорте в реальный проект:

- `codex/AGENTS.md` -> `AGENTS.md`
- `codex/skills/<skill>/SKILL.md` -> `.agents/skills/<skill>/SKILL.md`
