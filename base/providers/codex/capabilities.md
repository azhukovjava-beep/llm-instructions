# Codex Capabilities

Last verified against official docs: 2026-03-15

## Основные артефакты

- Global guidance: `AGENTS.override.md` или `AGENTS.md` в `CODEX_HOME` / `~/.codex`
- Project guidance: `AGENTS.md` или `AGENTS.override.md` по цепочке `repo root -> cwd`
- Skill directories: `.agents/skills/<skill-name>/SKILL.md`
- Approval policy: `codex/rules/*.rules` и `~/.codex/rules/*.rules`
- Multi-agent workflows: experimental feature in Codex

## Как загружается контекст

- Codex строит instruction chain один раз на запуск.
- Для глобального уровня использует `AGENTS.override.md`, иначе `AGENTS.md`.
- Для project scope проходит от project root к текущей директории и берет не более одного instruction file на директорию.
- Более близкие к `cwd` файлы переопределяют верхние, потому что конкатенируются позже.
- Skills работают по progressive disclosure: метаданные видны заранее, полный `SKILL.md` грузится при активации.
- Approval policy через `.rules` не является content guidance и должно моделироваться отдельно.

## Что важно для общей модели

Codex очень хорошо выражает:

- `instruction-set`
- `skill`
- `approval-policy`

И ограниченно/экспериментально выражает:

- `agent-profile` через multi-agent workflows

У Codex нет прямого аналога structured path-scoped rule file наподобие `.cursor/rules/*.mdc` или `.claude/rules/*.md` с frontmatter path selection. Поэтому path-scoped знание обычно надо переносить либо в ближайший directory-level `AGENTS.md`, либо в skill.

## Что считать platform-specific

Чаще всего platform-specific для Codex:

- `.rules` execution policy;
- experimental multi-agent configuration;
- `AGENTS.override.md` как особый override-layer;
- distinction between adapter storage and runtime storage for skills.

## Нормализованный маппинг

- `AGENTS.md` -> `instruction-set`
- `AGENTS.override.md` -> `instruction-set` + override semantics
- `.agents/skills/*/SKILL.md` -> `skill`
- `codex/rules/*.rules` -> `approval-policy`
- multi-agent config -> `agent-profile` или `platform-exception`
