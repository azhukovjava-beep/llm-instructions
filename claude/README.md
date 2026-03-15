# Claude

Папка для Claude Code-специфичной адаптации общей базы.

## Роль в общей структуре

- Канонический общий материал хранится в `../base/`.
- В `claude/` лежат как существующие marketplace/plugin-артефакты, так и сгенерированный shared layer для Claude Code.
- Если правило или инструкция должны жить во всех платформах, сначала их стоит оформить в `../base/`.

## Что здесь уже есть

Существующий Claude-specific слой:

- `.claude-plugin/`
- `plugins/`
- `agents/awesome-claude-code-subagents/`

Сгенерированный shared layer:

- `CLAUDE.md`
- `.claude/rules/`
- `.claude/skills/`
- `.claude/agents/`
- `guidelines/`, синхронизируемые с `base/guidelines/`

## Installation

```bash
claude --marketplace /path/to/claude
```

## Как обновлять shared layer

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

## Structure

```text
claude/
|-- .claude/
|   |-- agents/
|   |-- rules/
|   `-- skills/
|-- .claude-plugin/
|   `-- marketplace.json
|-- agents/
|   `-- awesome-claude-code-subagents/
|-- guidelines/
|   |-- code-review.md
|   `-- development.md
|-- plugins/
|   `-- <plugin-name>/
`-- CLAUDE.md
```

## Agents

Agents are sourced from [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) as a git submodule.

### First-time clone

```bash
git clone --recurse-submodules <repo-url>
```

### Existing clone

```bash
git submodule update --init --recursive
```

### Installing agents

Use the interactive installer:

```bash
./agents/awesome-claude-code-subagents/install-agents.sh
```

Or copy the agents you need manually:

```bash
# Global (all projects)
cp agents/awesome-claude-code-subagents/categories/<category>/<agent>.md ~/.claude/agents/

# Local (current project only)
cp agents/awesome-claude-code-subagents/categories/<category>/<agent>.md .claude/agents/
```

### Updating agents

```bash
git submodule update --remote agents/awesome-claude-code-subagents
```

## Adding a Plugin

1. Create a directory in `plugins/`
2. Add `.claude-plugin/plugin.json` with plugin metadata
3. Add plugin components (agents, commands, skills, hooks)
4. Register the plugin in `.claude-plugin/marketplace.json`
