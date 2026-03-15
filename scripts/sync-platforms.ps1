Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

function Read-RepoFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath
    )

    $path = Join-Path $repoRoot $RelativePath
    return Get-Content -Path $path -Raw
}

function Write-RepoFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $path = Join-Path $repoRoot $RelativePath
    $parent = Split-Path -Parent $path
    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $normalized = $Content.Trim() + [Environment]::NewLine
    Set-Content -Path $path -Value $normalized -Encoding utf8
}

function Trim-TopHeading {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    return ($Content -replace '^\s*# .+\r?\n+', '').Trim()
}

function New-GeneratedMarkdown {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [string[]]$Sections
    )

    $body = ($Sections | Where-Object { $_ -and $_.Trim() } | ForEach-Object { $_.Trim() }) -join "`r`n`r`n"
    return "# $Title`r`n`r`n> Generated from base/ by scripts/sync-platforms.ps1. Update shared content in base/ first when possible.`r`n`r`n$body"
}

function New-CursorRule {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $true)]
        [bool]$AlwaysApply,
        [Parameter(Mandatory = $true)]
        [string]$Body,
        [string[]]$Globs = @()
    )

    $alwaysValue = if ($AlwaysApply) { 'true' } else { 'false' }
    $globsSection = if ($Globs.Count -eq 0) {
        'globs: []'
    } else {
        "globs:`r`n" + (($Globs | ForEach-Object { "  - $_" }) -join "`r`n")
    }

    return "---`r`ndescription: $Description`r`n$globsSection`r`nalwaysApply: $alwaysValue`r`n---`r`n`r`n# $Title`r`n`r`nGenerated from base/ by scripts/sync-platforms.ps1.`r`n`r`n$($Body.Trim())"
}

$projectDefaults = Trim-TopHeading (Read-RepoFile 'base/instructions/core/project-defaults.md')
$developmentGuidelines = Trim-TopHeading (Read-RepoFile 'base/guidelines/development.md')
$codeReviewGuidelines = Trim-TopHeading (Read-RepoFile 'base/guidelines/code-review.md')
$codeReviewWorkflow = Trim-TopHeading (Read-RepoFile 'base/instructions/workflows/code-review.md')
$codeReviewerProfile = Trim-TopHeading (Read-RepoFile 'base/agents/profiles/code-reviewer.md')
$fullstackProfile = Trim-TopHeading (Read-RepoFile 'base/agents/profiles/fullstack-developer.md')

$sharedSourceSection = @"
## Source Of Truth

- Shared meaning lives in ../base/.
- schema/, providers/ and mappings/ define how the content should be adapted per platform.
- Generated platform files should be treated as adapters, not as the canonical source.
"@

$sharedSyncSection = @"
## Sync Notes

- Run pwsh ./scripts/sync-platforms.ps1 or powershell -File .\\scripts\\sync-platforms.ps1 from the repository root to refresh the generated platform files.
- If a change is common across providers, update base/ first.
- If a change is platform-specific, document the exception in base/providers/ or base/instructions/exceptions/.
"@

$codexAgents = New-GeneratedMarkdown -Title 'Codex Instructions' -Sections @(
    $sharedSourceSection,
    "## Project Core`r`n`r`n$projectDefaults",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines",
    "## Shared Review Workflow`r`n`r`n$codeReviewWorkflow",
    @"
## Shared Skills

- skills/code-review/SKILL.md for focused code review work.
- skills/fullstack-developer/SKILL.md for end-to-end feature work.
"@,
    $sharedSyncSection
)

$codexCodeReviewSkill = New-GeneratedMarkdown -Title 'Code Review Skill' -Sections @(
    "## Role Profile`r`n`r`n$codeReviewerProfile",
    "## Workflow`r`n`r`n$codeReviewWorkflow",
    "## Shared Review Rules`r`n`r`n$codeReviewGuidelines"
)

$codexFullstackSkill = New-GeneratedMarkdown -Title 'Fullstack Developer Skill' -Sections @(
    "## Role Profile`r`n`r`n$fullstackProfile",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines",
    @"
## Working Mode

- Use this skill when work spans frontend, backend and tests.
- Keep data contracts aligned across layers.
- Escalate cross-cutting risks before making irreversible changes.
"@
)

$cursorAgents = New-GeneratedMarkdown -Title 'Cursor Project Instructions' -Sections @(
    @"
## Adapter Role

- Prefer the structured rules in rules/.
- Keep this file as a lightweight fallback for tools or workflows that only read root-level instructions.
"@,
    "## Project Core`r`n`r`n$projectDefaults",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines",
    $sharedSyncSection
)

$cursorProjectCoreRuleBody = @"
## Project Core

$projectDefaults

## Shared Development Guidance

$developmentGuidelines

## Sync Reminder

- Treat base/ as the source of truth.
- Refresh generated outputs through `scripts/sync-platforms.ps1`.
"@

$cursorCodeReviewRuleBody = @"
## Role Profile

$codeReviewerProfile

## Workflow

$codeReviewWorkflow

## Review Rules

$codeReviewGuidelines
"@

$cursorFullstackRuleBody = @"
## Role Profile

$fullstackProfile

## Shared Development Guidance

$developmentGuidelines
"@

$cursorProjectCoreRule = New-CursorRule -Title 'Project Core Rule' -Description 'Core repository instructions shared across providers.' -AlwaysApply $true -Body $cursorProjectCoreRuleBody
$cursorCodeReviewRule = New-CursorRule -Title 'Code Review Rule' -Description 'Use this rule when reviewing code or auditing recent changes.' -AlwaysApply $false -Body $cursorCodeReviewRuleBody
$cursorFullstackRule = New-CursorRule -Title 'Fullstack Development Rule' -Description 'Use this rule for work that spans frontend, backend and tests.' -AlwaysApply $false -Body $cursorFullstackRuleBody

$claudeMain = New-GeneratedMarkdown -Title 'Claude Instructions' -Sections @(
    $sharedSourceSection,
    @"
## Claude-Specific Layout

- Use .claude/rules/ for reusable shared rules.
- Use .claude/skills/ for reusable workflows.
- Use .claude/agents/ for specialist agent profiles.
"@,
    "## Project Core`r`n`r`n$projectDefaults",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines",
    @"
## Generated Companions

- .claude/rules/00-project-core.md
- .claude/rules/10-code-review.md
- .claude/skills/code-review/SKILL.md
- .claude/skills/fullstack-developer/SKILL.md
- .claude/agents/code-reviewer.md
- .claude/agents/fullstack-developer.md
"@,
    $sharedSyncSection
)

$claudeProjectRule = New-GeneratedMarkdown -Title 'Claude Project Core Rule' -Sections @(
    "## Project Core`r`n`r`n$projectDefaults",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines"
)

$claudeCodeReviewRule = New-GeneratedMarkdown -Title 'Claude Code Review Rule' -Sections @(
    "## Workflow`r`n`r`n$codeReviewWorkflow",
    "## Review Rules`r`n`r`n$codeReviewGuidelines"
)

$claudeCodeReviewSkill = New-GeneratedMarkdown -Title 'Claude Code Review Skill' -Sections @(
    "## Role Profile`r`n`r`n$codeReviewerProfile",
    "## Workflow`r`n`r`n$codeReviewWorkflow",
    "## Review Rules`r`n`r`n$codeReviewGuidelines"
)

$claudeFullstackSkill = New-GeneratedMarkdown -Title 'Claude Fullstack Developer Skill' -Sections @(
    "## Role Profile`r`n`r`n$fullstackProfile",
    "## Shared Development Guidance`r`n`r`n$developmentGuidelines"
)

$claudeCodeReviewerAgent = New-GeneratedMarkdown -Title 'Claude Agent: Code Reviewer' -Sections @(
    "## Role Profile`r`n`r`n$codeReviewerProfile",
    @"
## Expected Behavior

- Prioritize bugs, regressions, missing tests, security issues and performance risks.
- Keep feedback concrete and evidence-based.
- Prefer concise findings ordered by severity.
"@
)

$claudeFullstackAgent = New-GeneratedMarkdown -Title 'Claude Agent: Fullstack Developer' -Sections @(
    "## Role Profile`r`n`r`n$fullstackProfile",
    @"
## Expected Behavior

- Think across frontend, backend, API contracts and tests as one system.
- Call out integration risks early.
- Keep the solution cohesive across layers.
"@
)

$codexSkillsReadme = New-GeneratedMarkdown -Title 'Codex Skills' -Sections @(
    @"
## Generated Skills

- code-review
- fullstack-developer

Both skills are rendered from base/ and should be refreshed through `scripts/sync-platforms.ps1`.
"@
)

$cursorRulesReadme = New-GeneratedMarkdown -Title 'Cursor Rules' -Sections @(
    @"
## Generated Rules

- 00-project-core.mdc
- 20-code-review.mdc
- 30-fullstack-development.mdc

These rules are rendered from base/ and are intended to be exported to .cursor/rules/ in a target repository.
"@
)

$claudeDotRulesReadme = New-GeneratedMarkdown -Title 'Claude Rules' -Sections @(
    @"
## Generated Rules

- 00-project-core.md
- 10-code-review.md

These rule files are rendered from base/ and are intended to be exported to .claude/rules/ in a target repository.
"@
)

$claudeDotSkillsReadme = New-GeneratedMarkdown -Title 'Claude Skills' -Sections @(
    @"
## Generated Skills

- code-review
- fullstack-developer

These skill folders are rendered from base/ and are intended to be exported to .claude/skills/ in a target repository.
"@
)

$claudeDotAgentsReadme = New-GeneratedMarkdown -Title 'Claude Agents' -Sections @(
    @"
## Generated Agents

- code-reviewer.md
- fullstack-developer.md

These agent profiles are rendered from base/ and are intended to be exported to .claude/agents/ in a target repository.
"@
)

Write-RepoFile -RelativePath 'codex/AGENTS.md' -Content $codexAgents
Write-RepoFile -RelativePath 'codex/skills/README.md' -Content $codexSkillsReadme
Write-RepoFile -RelativePath 'codex/skills/code-review/SKILL.md' -Content $codexCodeReviewSkill
Write-RepoFile -RelativePath 'codex/skills/fullstack-developer/SKILL.md' -Content $codexFullstackSkill

Write-RepoFile -RelativePath 'cursor/AGENTS.md' -Content $cursorAgents
Write-RepoFile -RelativePath 'cursor/rules/README.md' -Content $cursorRulesReadme
Write-RepoFile -RelativePath 'cursor/rules/00-project-core.mdc' -Content $cursorProjectCoreRule
Write-RepoFile -RelativePath 'cursor/rules/20-code-review.mdc' -Content $cursorCodeReviewRule
Write-RepoFile -RelativePath 'cursor/rules/30-fullstack-development.mdc' -Content $cursorFullstackRule

Write-RepoFile -RelativePath 'claude/CLAUDE.md' -Content $claudeMain
Write-RepoFile -RelativePath 'claude/.claude/rules/README.md' -Content $claudeDotRulesReadme
Write-RepoFile -RelativePath 'claude/.claude/rules/00-project-core.md' -Content $claudeProjectRule
Write-RepoFile -RelativePath 'claude/.claude/rules/10-code-review.md' -Content $claudeCodeReviewRule
Write-RepoFile -RelativePath 'claude/.claude/skills/README.md' -Content $claudeDotSkillsReadme
Write-RepoFile -RelativePath 'claude/.claude/skills/code-review/SKILL.md' -Content $claudeCodeReviewSkill
Write-RepoFile -RelativePath 'claude/.claude/skills/fullstack-developer/SKILL.md' -Content $claudeFullstackSkill
Write-RepoFile -RelativePath 'claude/.claude/agents/README.md' -Content $claudeDotAgentsReadme
Write-RepoFile -RelativePath 'claude/.claude/agents/code-reviewer.md' -Content $claudeCodeReviewerAgent
Write-RepoFile -RelativePath 'claude/.claude/agents/fullstack-developer.md' -Content $claudeFullstackAgent

Write-RepoFile -RelativePath 'claude/guidelines/code-review.md' -Content (Read-RepoFile 'base/guidelines/code-review.md')
Write-RepoFile -RelativePath 'claude/guidelines/development.md' -Content (Read-RepoFile 'base/guidelines/development.md')

$generatedFiles = @(
    'codex/AGENTS.md',
    'codex/skills/README.md',
    'codex/skills/code-review/SKILL.md',
    'codex/skills/fullstack-developer/SKILL.md',
    'cursor/AGENTS.md',
    'cursor/rules/README.md',
    'cursor/rules/00-project-core.mdc',
    'cursor/rules/20-code-review.mdc',
    'cursor/rules/30-fullstack-development.mdc',
    'claude/CLAUDE.md',
    'claude/.claude/rules/README.md',
    'claude/.claude/rules/00-project-core.md',
    'claude/.claude/rules/10-code-review.md',
    'claude/.claude/skills/README.md',
    'claude/.claude/skills/code-review/SKILL.md',
    'claude/.claude/skills/fullstack-developer/SKILL.md',
    'claude/.claude/agents/README.md',
    'claude/.claude/agents/code-reviewer.md',
    'claude/.claude/agents/fullstack-developer.md',
    'claude/guidelines/code-review.md',
    'claude/guidelines/development.md'
)

$generatedOutputs = @(
    [PSCustomObject]@{ path = 'codex/AGENTS.md'; provider = 'codex'; kind = 'instruction-set'; runtimeTarget = 'AGENTS.md' },
    [PSCustomObject]@{ path = 'codex/skills/README.md'; provider = 'codex'; kind = 'supporting-doc'; runtimeTarget = '.agents/skills/README.md' },
    [PSCustomObject]@{ path = 'codex/skills/code-review/SKILL.md'; provider = 'codex'; kind = 'skill'; runtimeTarget = '.agents/skills/code-review/SKILL.md' },
    [PSCustomObject]@{ path = 'codex/skills/fullstack-developer/SKILL.md'; provider = 'codex'; kind = 'skill'; runtimeTarget = '.agents/skills/fullstack-developer/SKILL.md' },
    [PSCustomObject]@{ path = 'cursor/AGENTS.md'; provider = 'cursor'; kind = 'instruction-set'; runtimeTarget = 'AGENTS.md' },
    [PSCustomObject]@{ path = 'cursor/rules/README.md'; provider = 'cursor'; kind = 'supporting-doc'; runtimeTarget = '.cursor/rules/README.md' },
    [PSCustomObject]@{ path = 'cursor/rules/00-project-core.mdc'; provider = 'cursor'; kind = 'rule-set'; runtimeTarget = '.cursor/rules/00-project-core.mdc' },
    [PSCustomObject]@{ path = 'cursor/rules/20-code-review.mdc'; provider = 'cursor'; kind = 'rule-set'; runtimeTarget = '.cursor/rules/20-code-review.mdc' },
    [PSCustomObject]@{ path = 'cursor/rules/30-fullstack-development.mdc'; provider = 'cursor'; kind = 'rule-set'; runtimeTarget = '.cursor/rules/30-fullstack-development.mdc' },
    [PSCustomObject]@{ path = 'claude/CLAUDE.md'; provider = 'claude'; kind = 'instruction-set'; runtimeTarget = 'CLAUDE.md' },
    [PSCustomObject]@{ path = 'claude/.claude/rules/README.md'; provider = 'claude'; kind = 'supporting-doc'; runtimeTarget = '.claude/rules/README.md' },
    [PSCustomObject]@{ path = 'claude/.claude/rules/00-project-core.md'; provider = 'claude'; kind = 'rule-set'; runtimeTarget = '.claude/rules/00-project-core.md' },
    [PSCustomObject]@{ path = 'claude/.claude/rules/10-code-review.md'; provider = 'claude'; kind = 'rule-set'; runtimeTarget = '.claude/rules/10-code-review.md' },
    [PSCustomObject]@{ path = 'claude/.claude/skills/README.md'; provider = 'claude'; kind = 'supporting-doc'; runtimeTarget = '.claude/skills/README.md' },
    [PSCustomObject]@{ path = 'claude/.claude/skills/code-review/SKILL.md'; provider = 'claude'; kind = 'skill'; runtimeTarget = '.claude/skills/code-review/SKILL.md' },
    [PSCustomObject]@{ path = 'claude/.claude/skills/fullstack-developer/SKILL.md'; provider = 'claude'; kind = 'skill'; runtimeTarget = '.claude/skills/fullstack-developer/SKILL.md' },
    [PSCustomObject]@{ path = 'claude/.claude/agents/README.md'; provider = 'claude'; kind = 'supporting-doc'; runtimeTarget = '.claude/agents/README.md' },
    [PSCustomObject]@{ path = 'claude/.claude/agents/code-reviewer.md'; provider = 'claude'; kind = 'agent-profile'; runtimeTarget = '.claude/agents/code-reviewer.md' },
    [PSCustomObject]@{ path = 'claude/.claude/agents/fullstack-developer.md'; provider = 'claude'; kind = 'agent-profile'; runtimeTarget = '.claude/agents/fullstack-developer.md' },
    [PSCustomObject]@{ path = 'claude/guidelines/code-review.md'; provider = 'claude'; kind = 'mirrored-guideline'; runtimeTarget = 'supporting-doc' },
    [PSCustomObject]@{ path = 'claude/guidelines/development.md'; provider = 'claude'; kind = 'mirrored-guideline'; runtimeTarget = 'supporting-doc' }
)

$reportLines = @(
    '# Latest Sync Report',
    '',
    'This report is regenerated by scripts/sync-platforms.ps1.',
    '',
    '## Sources',
    '- base/instructions/core/project-defaults.md',
    '- base/instructions/workflows/code-review.md',
    '- base/guidelines/development.md',
    '- base/guidelines/code-review.md',
    '- base/agents/profiles/code-reviewer.md',
    '- base/agents/profiles/fullstack-developer.md',
    '',
    '## Generated Outputs'
)
$reportLines += $generatedOutputs | ForEach-Object { "- $($_.path) -> $($_.runtimeTarget) [$($_.provider) / $($_.kind)]" }
$reportLines += @(
    '',
    '## Validation',
    '- Run powershell -ExecutionPolicy Bypass -File .\scripts\validate-sync.ps1 on Windows PowerShell.',
    '- Run pwsh ./scripts/validate-sync.ps1 on PowerShell 7.'
)

Write-RepoFile -RelativePath 'reports/latest-sync-report.md' -Content ($reportLines -join "`r`n")
Write-RepoFile -RelativePath 'reports/generated-files.json' -Content (($generatedOutputs | ConvertTo-Json -Depth 3))

Write-Host 'Synced platform adapters from base:'
$generatedFiles | ForEach-Object { Write-Host " - $_" }
Write-Host ' - reports/latest-sync-report.md'
Write-Host ' - reports/generated-files.json'





