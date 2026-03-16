---
name: changeset
description: "Use when creating a changeset file for version tracking. Analyzes git changes, determines version type and scope automatically."
user-invocable: true
---

# Changeset

Automates creation of changeset files for Kaiten project version tracking.

## Workflow

### 1. Get Package Name

Read package name from `package.json` (lowercase):

```bash
node -p "require('./package.json').name.toLowerCase()"
```

This will be used as the package identifier in the changeset file.

### 2. Analyze Changes

```bash
git diff origin/master --name-only
git diff origin/master --stat
```

### 3. Determine Version Type

| Pattern | Type |
|---------|------|
| New files in controllers/routes, new exports | `minor` |
| Changes to existing files, bug fixes | `patch` |
| Breaking changes, API removal | `major` (requires confirmation) |

### 4. Determine Scope

| File Path | Scope |
|-----------|-------|
| `App/kaiten/client/cards/` | `cards` |
| `App/kaiten/client/boards/` | `boards` |
| `App/service-desk/` | `sd-*` |
| `controllers/` | controller name |
| Multiple areas | most significant or generic |

### 5. Check for Migrations

If files containing `schema` in kaiten-lib are changed — add `[MIGRATION]` to description.

### 6. Generate File Name

Format: `adjective-noun-noun.md` (random words separated by hyphens).

Use bash to generate:
```bash
# Generate random name from predefined word lists
ADJECTIVES=(brave calm cool dark deep fast firm free gold gray green high kind long lost mild pure rare rich safe slow soft tall thin warm wild wise)
NOUNS=(ants bear bird boat book cake cats chip code crow dawn deer door dove duck dust echo farm fish fork gate goat gold hall hawk hill home horn jade king lake lamp leaf lion moon moth nest orca palm park pear pine pond rain rice road rock rose salt sand seal seed ship snow song star swan team tree vase vine wave wolf wood yarn)

ADJ=${ADJECTIVES[$RANDOM % ${#ADJECTIVES[@]}]}
NOUN1=${NOUNS[$RANDOM % ${#NOUNS[@]}]}
NOUN2=${NOUNS[$RANDOM % ${#NOUNS[@]}]}

echo "$ADJ-$NOUN1-$NOUN2.md"
```

### 7. Create File

Create file in `.changeset/` directory:

```markdown
---
"<package-name>": <version-type>
---

<description>

[PR #<number>](<pr-url>)
```

Where:
- `<package-name>`: from package.json (lowercase)
- `<version-type>`: `patch`, `minor`, or `major`
- `<description>`: concise plain-text description of changes (NO conventional commit prefix like `fix():` — just the text)
- `[PR #<number>](<pr-url>)`: link to the GitHub PR (required, added on a separate line after an empty line)

### 8. Check for Existing Changesets

```bash
ls .changeset/*.md | grep -v README.md | wc -l
```

If more than one file exists — warn user and ask if old ones should be deleted.

### 9. Confirm with User

Show the created file to the user. Do NOT commit automatically — ask the user if they want to commit.

## File Format Example

For a project with `"name": "kaiten"` in package.json:

```markdown
---
"kaiten": patch
---

use commentAttachments instead of deprecated files field

[PR #15400](https://github.com/flowfast/kaiten/pull/15400)
```

For a project with `"name": "MyApp"` in package.json:

```markdown
---
"myapp": minor
---

add OAuth2 authentication support

[PR #123](https://github.com/flowfast/myapp/pull/123)
```

## Rules

- Description must be in English
- Use plain text for description (NO conventional commit prefixes like `fix():` or `feat():`)
- Always include a PR link on a separate line
- No emojis
- Keep description concise (one line)
- Always check for existing changesets before creating new one
- Do NOT commit automatically — confirm with the user first

## Red Flags

- DO NOT create changeset without analyzing git diff first
- DO NOT guess the version type — analyze actual changes
- DO NOT leave multiple changeset files without user confirmation
- DO NOT commit without user confirmation
- DO NOT use conventional commit format in changeset description
