# Claude Instructions

> Generated from base/ by scripts/sync-platforms.ps1. Update shared content in base/ first when possible.

## Source Of Truth

- Shared meaning lives in ../base/.
- schema/, providers/ and mappings/ define how the content should be adapted per platform.
- Generated platform files should be treated as adapters, not as the canonical source.

## Claude-Specific Layout

- Use .claude/rules/ for reusable shared rules.
- Use .claude/skills/ for reusable workflows.
- Use .claude/agents/ for specialist agent profiles.

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

## Generated Companions

- .claude/rules/00-project-core.md
- .claude/rules/10-code-review.md
- .claude/skills/code-review/SKILL.md
- .claude/skills/fullstack-developer/SKILL.md
- .claude/agents/code-reviewer.md
- .claude/agents/fullstack-developer.md

## Sync Notes

- Run pwsh ./scripts/sync-platforms.ps1 or powershell -File .\\scripts\\sync-platforms.ps1 from the repository root to refresh the generated platform files.
- If a change is common across providers, update base/ first.
- If a change is platform-specific, document the exception in base/providers/ or base/instructions/exceptions/.

