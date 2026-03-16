Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

function Get-ManagedHashes {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Manifest
    )

    $paths = @($Manifest | ForEach-Object { $_.path }) + @(
        'reports/latest-sync-report.md',
        'reports/generated-files.json'
    )

    $hashes = @{}
    foreach ($relativePath in $paths) {
        $fullPath = Join-Path $repoRoot $relativePath
        if (-not (Test-Path $fullPath)) {
            throw "Managed file is missing: $relativePath"
        }

        $hashes[$relativePath] = (Get-FileHash -Path $fullPath -Algorithm SHA256).Hash
    }

    return $hashes
}

Push-Location $repoRoot
try {
    & (Join-Path $PSScriptRoot 'sync-platforms.ps1')

    $manifestPath = Join-Path $repoRoot 'reports/generated-files.json'
    if (-not (Test-Path $manifestPath)) {
        throw "Generated files manifest not found: $manifestPath"
    }

    $manifest = Get-Content -Path $manifestPath -Raw | ConvertFrom-Json
    $before = Get-ManagedHashes -Manifest $manifest

    & (Join-Path $PSScriptRoot 'sync-platforms.ps1')
    $after = Get-ManagedHashes -Manifest $manifest

    $changed = @()
    foreach ($path in $before.Keys) {
        if ($before[$path] -ne $after[$path]) {
            $changed += $path
        }
    }

    if ($changed.Count -gt 0) {
        Write-Host 'Sync validation failed. Re-running sync changed managed files:' -ForegroundColor Red
        $changed | ForEach-Object { Write-Host " - $_" }
        exit 1
    }

    Write-Host 'Sync validation passed. The sync pipeline is deterministic for managed files.' -ForegroundColor Green
}
finally {
    Pop-Location
}
