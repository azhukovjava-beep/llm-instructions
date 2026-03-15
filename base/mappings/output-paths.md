# Output Paths

Этот файл фиксирует два уровня путей:

1. Где артефакт хранится внутри этого репозитория.
2. Во что он должен превращаться в реальном проекте пользователя.

## Adapter outputs in this repository

| Canonical output | Repo adapter path | Runtime target |
|---|---|---|
| Codex instruction set | `codex/AGENTS.md` | `AGENTS.md` |
| Codex skills | `codex/skills/<skill>/SKILL.md` | `.agents/skills/<skill>/SKILL.md` |
| Cursor instruction set | `cursor/AGENTS.md` | `AGENTS.md` |
| Cursor rules | `cursor/rules/<rule>.mdc` | `.cursor/rules/<rule>.mdc` |
| Claude instruction set | `claude/CLAUDE.md` | `CLAUDE.md` |
| Claude shared rules | `claude/.claude/rules/*.md` | `.claude/rules/*.md` |
| Claude shared skills | `claude/.claude/skills/<skill>/SKILL.md` | `.claude/skills/<skill>/SKILL.md` |
| Claude shared agents | `claude/.claude/agents/*.md` | `.claude/agents/*.md` |
| Claude mirrored guidelines | `claude/guidelines/*.md` | optional supporting docs or imported references |
| Claude plugin skills | `claude/plugins/<plugin>/skills/...` | provider/plugin-specific layout |

## Зачем это нужно

Адаптер в этом репозитории не обязан совпадать с runtime target один в один.

Например:

- в репозитории удобно держать Codex-материалы внутри `codex/`;
- но при экспорте в пользовательский проект skill должен лечь в `.agents/skills/`;
- Cursor rule должен оказаться в `.cursor/rules/`;
- Claude shared layer раскладывается между `CLAUDE.md`, `.claude/rules/`, `.claude/skills/` и `.claude/agents/`.

Именно это разделение должен использовать sync pipeline.
