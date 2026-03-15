# Codex Instructions

> Generated from base/ by scripts/sync-platforms.ps1. Update shared content in base/ first when possible.

## Source Of Truth

- Shared meaning lives in ../base/.
- schema/, providers/ and mappings/ define how the content should be adapted per platform.
- Generated platform files should be treated as adapters, not as the canonical source.

## Project Core

Это референсный `instruction-set`, который можно использовать как основу для генерации платформенных project instructions.

## Назначение

Содержать самый верхний слой общих указаний, которые нужны почти в любом репозитории этого семейства.

## Состав

- краткое описание проекта и структуры;
- рабочие договоренности по изменениям;
- правила осторожной работы с git и локальными файлами;
- ссылки на более узкие правила из `../guidelines/` и `../instructions/workflows/`.

## Как использовать

- Для Codex обычно рендерится в `AGENTS.md`.
- Для Claude обычно рендерится в `CLAUDE.md` или в главный общий блок.
- Для Cursor обычно рендерится либо в root `AGENTS.md`, либо раскладывается на `Always` rules.

## Связанные материалы

- `../../guidelines/code-review.md`
- `../../guidelines/development.md`
- `../workflows/code-review.md`

## Shared Development Guidance

Recommended agents and roles for writing new code across Kaiten platform repositories.

## By Task Type

| Task | Recommended role |
|---|---|
| React components, hooks, UI logic | React specialist |
| JavaScript code | JavaScript specialist |
| TypeScript code | TypeScript specialist |
| Express controllers, API endpoints | Backend developer |
| Full-stack features | Full-stack developer |
| SQL queries, migrations, indexes | Database administrator |
| Security review | Security engineer |
| Performance optimization | Performance engineer |
| Tests | Test automator |
| CI/CD, Docker, deployment | DevOps engineer |

## Shared Review Workflow

Это нормализованный workflow для code review, который может быть выражен в любой из поддерживаемых платформ.

## Цель

Проверять изменения на correctness, regression risk, performance impact, security issues и test gaps.

## Обязательные шаги

1. Понять пользовательский или продуктовый эффект изменения.
2. Проверить корректность логики и edge cases.
3. Проверить риски по производительности и базе данных.
4. Проверить вопросы безопасности и авторизации.
5. Проверить наличие или отсутствие нужных тестов.
6. Сформулировать findings в порядке приоритета.

## Связь с общими правилами

Детальные проектные критерии ревью лежат в `../../guidelines/code-review.md`.

## Платформенная адаптация

- Claude: как review guideline или skill.
- Codex: как skill или раздел в `AGENTS.md`.
- Cursor: как `Agent Requested` / `Manual` rule.

## Shared Skills

- skills/code-review/SKILL.md for focused code review work.
- skills/fullstack-developer/SKILL.md for end-to-end feature work.

## Sync Notes

- Run pwsh ./scripts/sync-platforms.ps1 or powershell -File .\\scripts\\sync-platforms.ps1 from the repository root to refresh the generated platform files.
- If a change is common across providers, update base/ first.
- If a change is platform-specific, document the exception in base/providers/ or base/instructions/exceptions/.

