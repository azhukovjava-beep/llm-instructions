# Claude Capabilities

Last verified against official docs: 2026-03-15

## Основные артефакты

- Project instructions: `./CLAUDE.md` или `./.claude/CLAUDE.md`
- User instructions: `~/.claude/CLAUDE.md`
- Managed instructions: OS-level managed `CLAUDE.md`
- Scoped rules: `.claude/rules/**/*.md`
- Skills: `.claude/skills/<skill-name>/SKILL.md`
- Subagents: `.claude/agents/*.md`
- Hooks: через `settings.json`
- Auto memory: `~/.claude/projects/<project>/memory/`

## Как загружается контекст

- `CLAUDE.md` в ancestor directories загружаются в начале сессии.
- `CLAUDE.md` в поддиректориях подхватываются on-demand, когда Claude читает файлы из этих директорий.
- `.claude/rules/*.md` без `paths` загружаются безусловно.
- `.claude/rules/*.md` с `paths` включаются при совпадении path patterns.
- Skills грузятся по progressive disclosure: описание доступно, полный `SKILL.md` загружается при активации.
- Subagents имеют отдельный контекст и собственные ограничения по инструментам.
- Auto memory хранится отдельно от project instructions и не считается portable repo artifact.

## Что важно для общей модели

Claude Code умеет выражать почти все типы сущностей, которые нам нужны:

- `instruction-set`
- `rule-set`
- `skill`
- `agent-profile`
- `hook`
- `memory-source`

Это делает Claude самым богатым источником функциональности среди текущих трех платформ. Поэтому при переносе из Claude в другие платформы нужно особенно аккуратно выявлять, что является portable, а что остается `platform-exception`.

## Что считать platform-specific

Чаще всего platform-specific для Claude:

- auto memory;
- hooks;
- managed policy locations;
- plugin packaging;
- path-specific rule semantics, если в другой платформе нет прямого аналога.

## Нормализованный маппинг

- `CLAUDE.md` -> `instruction-set`
- `.claude/rules/*.md` -> `rule-set`
- `.claude/skills/*/SKILL.md` -> `skill`
- `.claude/agents/*.md` -> `agent-profile`
- settings hooks -> `hook`
- auto memory -> `memory-source`
