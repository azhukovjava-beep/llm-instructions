# Sync Scripts

Run the shared sync pipeline from the repository root.

Recommended on Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-platforms.ps1
```

Or with PowerShell 7:

```powershell
pwsh ./scripts/sync-platforms.ps1
```

Validate that generated files are up to date:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-sync.ps1
```

Or with PowerShell 7:

```powershell
pwsh ./scripts/validate-sync.ps1
```

What the sync script does:

- reads the shared content from `base/`;
- regenerates the current adapter outputs for `codex/`, `cursor/` and `claude/`;
- keeps `claude/guidelines/` aligned with the shared base;
- refreshes the first shared skills, rules and agent profiles;
- writes deterministic reports to `reports/`.

If a change belongs to all platforms, update `base/` first and then rerun the sync script.
