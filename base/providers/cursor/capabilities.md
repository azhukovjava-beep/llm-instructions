# Cursor Capabilities

Last verified against official docs: 2026-03-15

## Основные артефакты

- Project Rules: `.cursor/rules/*.mdc`
- User Rules: global plain-text rules in settings
- Simple project instructions: root-level `AGENTS.md`
- Legacy project instructions: `.cursorrules`
- CLI compatibility layer: Cursor CLI reads root `AGENTS.md` and `CLAUDE.md` alongside `.cursor/rules`

## Как загружается контекст

- `.cursor/rules/*.mdc` являются основным project-scoped форматом.
- Rule types задаются через metadata и режимы: `Always`, `Auto Attached`, `Agent Requested`, `Manual`.
- Nested `.cursor/rules` в поддиректориях поддерживаются и scoped to that folder.
- Root-level `AGENTS.md` - упрощенный формат без metadata, без scoping и без split across multiple files.
- `.cursorrules` считается legacy и не должен быть главным выходным форматом для новой системы.

## Что важно для общей модели

Cursor лучше всего выражает:

- `rule-set`
- `instruction-set`

Через `.cursor/rules` можно моделировать почти все project-level знания, особенно если разбивать их на небольшие тематические rule files.

Public docs Cursor сейчас делают упор именно на rules, поэтому для общей модели reusable knowledge в Cursor лучше представлять через `.mdc` rules, а не пытаться изобретать skill-like слой без официального формата.

## Что считать platform-specific

Чаще всего platform-specific для Cursor:

- MDC frontmatter (`description`, `globs`, `alwaysApply`);
- rule types `Always`, `Auto Attached`, `Agent Requested`, `Manual`;
- root-only ограничения для `AGENTS.md`;
- legacy `.cursorrules`.

## Нормализованный маппинг

- `.cursor/rules/*.mdc` -> `rule-set`
- root `AGENTS.md` -> `instruction-set`
- User Rules -> `instruction-set` вне репозитория
- `.cursorrules` -> legacy `instruction-set`
