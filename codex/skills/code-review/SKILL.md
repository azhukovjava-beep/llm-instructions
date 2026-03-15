# Code Review Skill

> Generated from base/ by scripts/sync-platforms.ps1. Update shared content in base/ first when possible.

## Role Profile

## Цель

Искать bugs, regressions, missing tests, security issues и performance risks.

## Когда использовать

- pull request review;
- pre-merge self-check;
- incident-driven audit of recent changes.

## Ограничения

- не переписывать код без необходимости;
- не фокусироваться только на стиле;
- сначала сообщать о важных findings.

## Платформенная упаковка

- Claude: subagent или skill.
- Codex: skill.
- Cursor: requested/manual review rule.

## Workflow

Это нормализованный workflow для code review, который может быть выражен в любой из поддерживаемых платформ.

## Цель

Проверять изменения на correctness, regression risk, performance impact, security issues и test gaps.

## Обязательные шаги

1. Понять пользовательский или продуктовый эффект изменения.
2. Проверить корректность логики и edge cases.
3. Проверить риски по производительности и базе данных.
4. Проверить вопросы безопасности и авторизации.
5. Проверить наличие или отсутствие нужных тестов.
6. Сформулировать findings в порядке приоритета.

## Связь с общими правилами

Детальные проектные критерии ревью лежат в `../../guidelines/code-review.md`.

## Платформенная адаптация

- Claude: как review guideline или skill.
- Codex: как skill или раздел в `AGENTS.md`.
- Cursor: как `Agent Requested` / `Manual` rule.

## Shared Review Rules

Shared code review rules for all Kaiten platform repositories.

## Performance

This is a high-load project. Database and server resource optimization is critical - always minimize load and conserve resources.

## Frontend

- **No unnecessary backend requests**: Ensure there are no redundant or duplicate API calls. Reuse already fetched data, avoid re-fetching on every render, and leverage caching/memoization where appropriate.
- **Avoid unnecessary re-renders**: Use memoization (`useMemo`, `useCallback`, `React.memo`) in heavy lists and components with frequent Redux updates. At the same time, avoid excessive memoization where it adds complexity without measurable benefit.
- **Handle loading and error states**: UI must correctly display loading states and handle API errors gracefully - no silent failures or frozen UI.
- **Prefer lodash for emptiness/length checks**: Use `_.isEmpty(arr)` instead of `arr.length === 0`, and `!_.isEmpty(arr)` instead of `arr.length > 0`. For boolean flags use truthy checks (`if (flag)`) instead of strict comparison (`if (flag === true)`).

## Backend

- **Index coverage**: Every database query must be covered by an appropriate index. Verify that new queries utilize existing indexes or propose new ones.
- **No `SELECT *`**: Never select all columns. Every query must explicitly list the required columns.
- **No unnecessary or suboptimal DB queries**: Avoid redundant queries, N+1 problems, and unneeded joins. Combine queries where possible, use batch operations, and ensure query plans are efficient.
- **Input validation**: All request parameters (body, query, params) must be validated and sanitized before use to prevent injections and invalid data.
- **Pagination**: Queries returning lists must have pagination and limits to avoid fetching thousands of records in a single request.
- **Authorization and access control**: Endpoints must verify user permissions, not just authentication. Especially important for accessing data across companies/boards.

## Dependencies

- **`kaiten-lib` pinned to a commit hash is not an error**: During development, a developer first merges changes to `kaiten-lib`, which bumps its version. Then they update dependent PRs to replace the commit hash with the released version. Seeing a commit hash reference in a PR is a normal part of the workflow.

