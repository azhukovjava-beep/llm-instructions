# Provider Docs Registry

Last reviewed: 2026-03-15

Этот файл хранит официальный реестр источников, по которым sync-агент должен проверять актуальность платформ.

## Claude

- Official docs root: `https://docs.anthropic.com/`
- Claude Code overview: `https://code.claude.com/docs/en/overview`
- Memory and `CLAUDE.md`: `https://code.claude.com/docs/en/memory`
- Skills: `https://code.claude.com/docs/en/skills`
- Subagents: `https://code.claude.com/docs/en/sub-agents`
- Settings: `https://code.claude.com/docs/en/settings`
- Hooks: `https://code.claude.com/docs/en/hooks-guide`

Проверять при sync:

- locations and precedence of `CLAUDE.md`;
- `.claude/rules` semantics;
- skill format and placement;
- subagent format and scope;
- hook and memory behavior.

## Codex

- Codex overview: `https://developers.openai.com/codex`
- Codex CLI: `https://developers.openai.com/codex/cli`
- AGENTS.md guide: `https://developers.openai.com/codex/guides/agents-md`
- Skills: `https://developers.openai.com/codex/skills`
- Rules: `https://developers.openai.com/codex/rules`
- Multi-agents: `https://developers.openai.com/codex/multi-agent`
- Docs MCP: `https://developers.openai.com/resources/docs-mcp`

Проверять при sync:

- AGENTS discovery order;
- override semantics;
- skill directories and metadata;
- approval policy rules format;
- experimental multi-agent status.

## Cursor

- Docs root: `https://docs.cursor.com/`
- Rules: `https://docs.cursor.com/en/context`
- CLI behavior: `https://docs.cursor.com/en/cli/using`
- Ignore files: `https://docs.cursor.com/en/context/ignore-files`

Проверять при sync:

- `.cursor/rules` structure and MDC metadata;
- current `AGENTS.md` limitations;
- nested rule support;
- CLI compatibility with `AGENTS.md` and `CLAUDE.md`;
- deprecation status of `.cursorrules`.
