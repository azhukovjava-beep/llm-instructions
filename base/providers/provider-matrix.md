# Provider Matrix

Last reviewed: 2026-03-15

Эта таблица фиксирует, как текущие поддерживаемые платформы выражают похожие сущности.

| Capability | Claude Code | Codex | Cursor | Canonical model |
|---|---|---|---|---|
| Основной проектный instruction file | `CLAUDE.md` или `.claude/CLAUDE.md` | `AGENTS.md` | `AGENTS.md` или `.cursor/rules/*.mdc` | `instruction-set` |
| Пользовательский global слой | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` или `AGENTS.override.md` | User Rules в settings | `instruction-set` |
| Организационный managed слой | OS-level managed `CLAUDE.md` | admin / managed config layers | не моделируется как repo artifact | `instruction-set` / `provider-capability` |
| Иерархия по каталогам | ancestor `CLAUDE.md` + subdir on-demand | root -> cwd chain из `AGENTS.md`/`AGENTS.override.md` | nested `.cursor/rules`; `AGENTS.md` только root-level | `scope` + `load-mode` |
| Path-scoped rules | `.claude/rules/*.md` c `paths` | нет прямого аналога; nearest-dir docs | `.cursor/rules/*.mdc` c `globs` | `rule-set` |
| Reusable skills | `.claude/skills/<name>/SKILL.md` | `.agents/skills/<name>/SKILL.md` | native skill format не задокументирован; ближайший аналог - rule | `skill` |
| Specialist agents | `.claude/agents/*.md` | experimental multi-agents, portable default = skill | native agent-profile artifact не задокументирован | `agent-profile` |
| Hooks / lifecycle automation | settings `hooks` | через automation / shell / app server, но не как repo instruction artifact | не моделируется в repo rules docs | `hook` |
| Approval policy | permissions/settings | `.rules` files for execution policy | approvals mostly tool/runtime level | `approval-policy` |
| Auto memory | built-in project memory dir | instruction chain + app features, отдельный public memory artifact не выделен | public docs по rules делают упор на rules, не на repo memory files | `memory-source` |
| File imports / references | `@path` imports in `CLAUDE.md`; supporting files in skills | nested AGENTS + supporting files in skills | `@file` references from rule content | `supporting-resource` |

## Вывод для нашей базы

1. Общая модель должна считать `instruction-set`, `rule-set`, `skill` и `agent-profile` основными portable-сущностями.
2. `approval-policy`, `hook` и `memory-source` нужно держать как отдельные типы, потому что они плохо переносятся между провайдерами.
3. Cursor лучше считать rule-centric платформой.
4. Codex лучше считать AGENTS-plus-skills платформой.
5. Claude лучше считать memory-plus-rules-plus-skills-plus-agents платформой.
