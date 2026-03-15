---
name: updating-kaiten-lib
description: "Update kaiten-lib git dependency in any project with package.json. Handles version/commit hash changes, yarn.lock updates, and commits both files."
user-invocable: true
---

# Updating kaiten-lib

## Overview

`kaiten-lib` is a git dependency specified in package.json:
```json
"kaiten-lib": "git+ssh://git@github.com/kaiten-hq/kaiten-lib.git#<version-or-hash>"
```

## Version Formats

- **Version tag (NO `v` prefix):** `83.207.4`, `83.207.5`
- **Commit hash (short or full):** `6cc543e31`, `6cc543e31a2b3c4d5e6f7890`

## Workflow

### Step 1: Find and update package.json

1. Search for `kaiten-lib` in package.json using Grep or Read
2. Edit the version/hash after the `#` symbol:
   ```json
   "kaiten-lib": "git+ssh://git@github.com/kaiten-hq/kaiten-lib.git#NEW_VERSION"
   ```

### Step 2: Update yarn.lock

Run `yarn install` — this automatically updates yarn.lock with the new resolved reference.

```bash
yarn install
```

### Step 3: Commit BOTH files

Commit message template:
```
chore(deps): update kaiten-lib to <version>
```

Examples:
- `chore(deps): update kaiten-lib to 83.207.5`
- `chore(deps): update kaiten-lib to 6cc543e31`

Stage and commit:
```bash
git add package.json yarn.lock
git commit -m "chore(deps): update kaiten-lib to <version>"
```

## Red Flags — What NOT to Do

- **Never edit yarn.lock manually** — always use `yarn install`
- **Never skip `yarn install`** after changing package.json
- **Never commit only package.json** — always include yarn.lock
- **Never use `npm install`** — this project uses yarn

## Verification

After completing the update, verify:
1. `git status` shows both package.json and yarn.lock were committed
2. `yarn.lock` contains the new kaiten-lib reference
3. No uncommitted changes remain
