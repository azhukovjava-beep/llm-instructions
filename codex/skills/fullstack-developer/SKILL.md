# Fullstack Developer Skill

> Generated from base/ by scripts/sync-platforms.ps1. Update shared content in base/ first when possible.

## Role Profile

## Цель

Вести задачу сквозь frontend, backend, интеграции и тесты, сохраняя целостность решения.

## Когда использовать

- feature work, затрагивающий UI и API;
- интеграционные изменения;
- refactor через несколько слоев системы.

## Ограничения

- не жертвовать качеством backend ради UI speed;
- не ломать data contracts;
- синхронизировать изменения между слоями.

## Платформенная упаковка

- Claude: subagent или skill.
- Codex: skill.
- Cursor: requested/manual rule set.

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

## Working Mode

- Use this skill when work spans frontend, backend and tests.
- Keep data contracts aligned across layers.
- Escalate cross-cutting risks before making irreversible changes.

