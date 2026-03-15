# Provider Normalization

Этот файл описывает, как приводить похожие сущности разных платформ к общему виду.

## Базовый принцип

Нельзя считать, что одинаковые имена файлов означают одинаковую семантику.

Пример:

- `AGENTS.md` в Codex - основной chainable instruction source.
- `AGENTS.md` в Cursor - упрощенная root-level альтернатива structured rules.
- `CLAUDE.md` в Claude - memory/instruction source с собственной иерархией и on-demand загрузкой.

Поэтому нормализация идет не от имени файла, а от функции сущности.

## Канонические соответствия

| Провайдерская сущность | Канонический тип | Комментарий |
|---|---|---|
| `CLAUDE.md` | `instruction-set` | Основной instruction memory layer Claude |
| `.claude/rules/*.md` | `rule-set` / `rule` | Может быть global или path-specific |
| `.claude/skills/*/SKILL.md` | `skill` | Reusable workflow |
| `.claude/agents/*.md` | `agent-profile` | Специализированный исполнитель |
| Claude auto memory | `memory-source` | Machine-local накопленные знания |
| `AGENTS.md` в Codex | `instruction-set` | Главный project instruction chain |
| `AGENTS.override.md` в Codex | `instruction-set` + `platform-exception` | Override-слой той же сущности |
| `.agents/skills/*/SKILL.md` | `skill` | Репозиторные, user, admin или system skills |
| `codex/rules/*.rules` | `approval-policy` | Политика разрешений, а не контентные инструкции |
| `.cursor/rules/*.mdc` | `rule-set` | Structured rule artifact для Cursor |
| `AGENTS.md` в Cursor | `instruction-set` | Упрощенная альтернатива `.cursor/rules` |
| Cursor User Rules | `instruction-set` | Global plain-text rules вне репозитория |
| `.cursorrules` | `instruction-set` / legacy | Legacy-представление, не источник для новой модели |

## Что переносить напрямую, а что нет

Нормально переносится между платформами:

- общие инструкции проекта;
- кодстайл и workflow-правила;
- повторяемые навыки и playbooks;
- специализированные роли, если их можно выразить через skills или agents.

Требует адаптации:

- path-scoped rules;
- command approval и sandbox policy;
- auto memory / machine-local memory;
- hooks и event-driven automation;
- experimental multi-agent configuration.

Не надо считать portable по умолчанию:

- provider-specific settings JSON/TOML;
- private machine-local memory;
- UI-only metadata;
- enterprise policy delivery mechanisms.
