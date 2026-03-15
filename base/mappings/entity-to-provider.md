# Entity To Provider Mapping

Эта матрица отвечает на вопрос: во что превращать канонические сущности `base/` при генерации платформенных файлов.

| Canonical entity | Claude output | Codex output | Cursor output | Notes |
|---|---|---|---|---|
| `instruction-set` | `CLAUDE.md` или `.claude/CLAUDE.md` | `AGENTS.md` | root `AGENTS.md` или `Always` rule | Основной общий смысл |
| `rule` | отдельный раздел `CLAUDE.md` или `.claude/rules/*.md` | раздел в ближайшем `AGENTS.md` | отдельный `.mdc` rule file | Выбор зависит от scope |
| `rule-set` | `.claude/rules/*.md` | набор directory-level `AGENTS.md` / skill | `.cursor/rules/*.mdc` | Cursor здесь самый нативный |
| `skill` | `.claude/skills/<name>/SKILL.md` | `.agents/skills/<name>/SKILL.md` | `Manual` или `Agent Requested` rule + supporting files | В Cursor skill переносится как rule-pattern |
| `agent-profile` | `.claude/agents/<name>.md` | portable default: skill; optional: multi-agent config | portable default: `Agent Requested` rule | Нативный agent artifact есть не у всех |
| `memory-source` | auto memory / `CLAUDE.md` split | `AGENTS.md` chain | User Rules или root `AGENTS.md` | Machine-local memory не переносим напрямую |
| `approval-policy` | permissions/settings/hooks | `.rules` | обычно вне repo outputs | Не смешивать с content instructions |
| `hook` | settings hooks | app/CLI automation, not AGENTS | вне rule output | Отдельный automation layer |
| `platform-exception` | comment in provider docs or dedicated file | comment in provider docs or dedicated file | comment in provider docs or dedicated file | Не терять объяснение расхождений |

## Главное правило генерации

1. Если сущность portable, сначала ищем самый нативный выходной формат платформы.
2. Если нативного формата нет, переносим смысл в ближайший совместимый артефакт.
3. Если перенос без потерь невозможен, создаем `platform-exception` и явно отмечаем это в `base/providers/` и `base/mappings/`.
