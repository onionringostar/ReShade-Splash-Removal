$ErrorActionPreference = "Stop"

$Root = $PSScriptRoot
$Work = Join-Path $Root "Update-Work"
$Builds = Join-Path $Root "Builds"
$Log = Join-Path $Root "Last-Build-Log.txt"

try {
    Start-Transcript -Path $Log -Force | Out-Null
    Write-Host "Checking required tools..."
    foreach ($tool in @("git", "python")) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            throw "$tool was not found in PATH."
        }
    }

    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vswhere)) { throw "Visual Studio Installer (vswhere.exe) was not found." }
    $devenv = & $vswhere -latest -products * -version "[15.0,19.0)" -find "Common7\IDE\devenv.com" | Select-Object -First 1
    if (-not $devenv -or -not (Test-Path $devenv)) { throw "Visual Studio devenv.com was not found. Check the C++ desktop development workload." }

    Write-Host "Finding the newest official stable ReShade version tag..."
    # ReShade versions are published as Git tags. Do not use the GitHub
    # /releases/latest API endpoint, which may return 404 for this repository.
    $tagLines = & git ls-remote --tags --refs "https://github.com/crosire/reshade.git"
    if ($LASTEXITCODE -ne 0) { throw "Could not retrieve version tags from the official ReShade Git repository." }

    $stableTags = @(
        foreach ($line in $tagLines) {
            if ($line -match "\srefs/tags/(v?\d+\.\d+\.\d+)$") {
                $candidate = $Matches[1]
                $versionText = $candidate -replace '^v', ''
                try {
                    [pscustomobject]@{ Tag = $candidate; Version = [version]$versionText }
                } catch { }
            }
        }
    )
    if ($stableTags.Count -eq 0) { throw "No stable version tags were found in the official ReShade repository." }
    $tag = ($stableTags | Sort-Object Version -Descending | Select-Object -First 1).Tag
    Write-Host "Newest stable version selected: $tag"

    if (Test-Path $Work) { Remove-Item $Work -Recurse -Force }
    New-Item -ItemType Directory -Path $Builds -Force | Out-Null

    Write-Host "Downloading source and submodules..."
    & git clone --branch $tag --recurse-submodules --depth 1 "https://github.com/crosire/reshade.git" $Work
    if ($LASTEXITCODE -ne 0) { throw "Git could not download ReShade and its submodules." }

    $sourceFile = Join-Path $Work "source\runtime_gui.cpp"
    if (-not (Test-Path $sourceFile)) { throw "source\runtime_gui.cpp was not found." }
    $content = [System.IO.File]::ReadAllText($sourceFile)

    if ($content.Contains("_show_splash = false;")) {
        Write-Host "Splash-screen modification is already present."
    } else {
        $pattern = '(?m)^([ \t]*)ImGui::SetCurrentContext\(backup_context\);\r?\n[ \t]*\r?\n([ \t]*)_rebuild_font_atlas = false;'
        $matches = [regex]::Matches($content, $pattern)
        if ($matches.Count -ne 1) {
            throw "The expected splash-screen patch location was not found exactly once. Stopping safely; ReShade source may have changed."
        }
        $m = $matches[0]
        $firstIndent = $m.Groups[1].Value
        $indent = $m.Groups[2].Value
        $replacement = "${firstIndent}ImGui::SetCurrentContext(backup_context);`r`n`r`n${indent}_show_splash = false;`r`n`r`n${indent}_rebuild_font_atlas = false;"
        $content = $content.Substring(0, $m.Index) + $replacement + $content.Substring($m.Index + $m.Length)
        [System.IO.File]::WriteAllText($sourceFile, $content, [System.Text.UTF8Encoding]::new($false))
        Write-Host "Applied your splash-screen modification."
    }

    $solution = Join-Path $Work "ReShade.sln"
    if (-not (Test-Path $solution)) { throw "ReShade.sln was not found." }

    Write-Host "Building 32-bit Release..."
    & $devenv $solution /Rebuild "Release|32-bit" /Project "ReShade" /ProjectConfig "Release|Win32"
    if ($LASTEXITCODE -ne 0) { throw "The 32-bit Release build failed. See Last-Build-Log.txt." }

    Write-Host "Building 64-bit Release..."
    & $devenv $solution /Rebuild "Release|64-bit" /Project "ReShade" /ProjectConfig "Release|x64"
    if ($LASTEXITCODE -ne 0) { throw "The 64-bit Release build failed. See Last-Build-Log.txt." }

    $versionFolder = Join-Path $Builds $tag
    New-Item -ItemType Directory -Path $versionFolder -Force | Out-Null
    $bin = Join-Path $Work "bin"
    $dll32 = Get-ChildItem $bin -Filter "ReShade32.dll" -File -Recurse | Select-Object -First 1
    $dll64 = Get-ChildItem $bin -Filter "ReShade64.dll" -File -Recurse | Select-Object -First 1
    if (-not $dll32) { throw "ReShade32.dll was not found after the 32-bit build." }
    if (-not $dll64) { throw "ReShade64.dll was not found after the 64-bit build." }

    Copy-Item $dll32.FullName (Join-Path $versionFolder "ReShade32.dll") -Force
    Copy-Item $dll64.FullName (Join-Path $versionFolder "ReShade64.dll") -Force

    Write-Host ""
    Write-Host "SUCCESS! Built $tag" -ForegroundColor Green
    Write-Host "Files saved to: $versionFolder"
    Write-Host "Previous builds are preserved in the Builds folder."
    Stop-Transcript | Out-Null
    exit 0
}
catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "See Last-Build-Log.txt for details."
    try { Stop-Transcript | Out-Null } catch {}
    exit 1
}
