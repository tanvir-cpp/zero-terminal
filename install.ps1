#Requires -Version 5.1
<#
.SYNOPSIS
    Zero Terminal - One-command installer for a modern, clean Windows terminal experience.

.DESCRIPTION
    Installs and configures:
      - Oh My Posh (prompt engine)
      - CaskaydiaCove Nerd Font (with icons)
      - Zero Terminal Oh My Posh theme
      - PowerShell profile integration

.EXAMPLE
    irm https://raw.githubusercontent.com/YOUR_USERNAME/zero-terminal/main/install.ps1 | iex

.PARAMETER NoFont
    Skip Nerd Font installation.

.PARAMETER NoProfile
    Skip PowerShell profile update.

.PARAMETER Uninstall
    Remove Zero Terminal theme and revert profile changes.
#>

[CmdletBinding()]
param(
    [switch]$NoFont,
    [switch]$NoProfile,
    [switch]$Uninstall
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ─── Configuration ──────────────────────────────────────────────────────────
$ThemeName    = "zero"
$ThemeFile    = "$ThemeName.omp.json"
$RepoOwner    = "YOUR_USERNAME"          # <-- Replace with your GitHub username
$RepoName     = "zero-terminal"
$Branch       = "main"
$RawBase      = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch"
$ThemeUrl     = "$RawBase/theme/$ThemeFile"
$Font         = "CascadiaCode"

# ─── Helpers ────────────────────────────────────────────────────────────────
function Write-Step   { param($msg) Write-Host "  --> $msg" -ForegroundColor Cyan }
function Write-Ok     { param($msg) Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Fail   { param($msg) Write-Host "  [XX] $msg" -ForegroundColor Red }

function Write-Banner {
    $banner = @"

  ███████╗███████╗██████╗  ██████╗     ████████╗███████╗██████╗ ███╗   ███╗
     ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
       ███╔╝ █████╗  ██████╔╝██║   ██║       ██║   █████╗  ██████╔╝██╔████╔██║
      ███╔╝  ██╔══╝  ██╔══██╗██║   ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
     ███████╗███████╗██║  ██║╚██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║
     ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

                        Terminal Theme  |  github.com/$RepoOwner/$RepoName

"@
    Write-Host $banner -ForegroundColor Blue
}

function Test-CommandExists {
    param($cmd)
    $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue)
}

# ─── Uninstall ───────────────────────────────────────────────────────────────
function Invoke-Uninstall {
    Write-Step "Removing Zero Terminal theme..."

    # Remove from Oh My Posh themes dir
    if (Test-CommandExists oh-my-posh) {
        $themesPath = "$(oh-my-posh env | Where-Object { $_ -match 'POSH_THEMES_PATH' } | ForEach-Object { ($_ -split '=')[1] })"
        if (-not $themesPath) { $themesPath = "$env:POSH_THEMES_PATH" }
        $target = Join-Path $themesPath $ThemeFile
        if (Test-Path $target) {
            Remove-Item $target -Force
            Write-Ok "Theme file removed."
        }
    }

    # Clean profile
    $profileLines = Get-Content $PROFILE -ErrorAction SilentlyContinue
    if ($profileLines) {
        $cleaned = $profileLines | Where-Object { $_ -notmatch 'zero-terminal' -and $_ -notmatch 'oh-my-posh init' }
        $cleaned | Set-Content $PROFILE
        Write-Ok "PowerShell profile cleaned."
    }

    Write-Host ""
    Write-Ok "Zero Terminal uninstalled. Restart your terminal."
}

# ─── Install Oh My Posh ──────────────────────────────────────────────────────
function Install-OhMyPosh {
    if (Test-CommandExists oh-my-posh) {
        Write-Ok "Oh My Posh already installed."
        return
    }

    Write-Step "Installing Oh My Posh..."

    if (Test-CommandExists winget) {
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements --silent
    } elseif (Test-CommandExists scoop) {
        scoop install oh-my-posh
    } else {
        Write-Step "Installing Oh My Posh via official installer..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }

    # Refresh PATH so we can call oh-my-posh immediately
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Test-CommandExists oh-my-posh) {
        Write-Ok "Oh My Posh installed successfully."
    } else {
        Write-Fail "Oh My Posh installation failed. Please install manually: https://ohmyposh.dev/docs/installation/windows"
        exit 1
    }
}

# ─── Install Nerd Font ───────────────────────────────────────────────────────
function Install-NerdFont {
    if ($NoFont) {
        Write-Warn "Skipping font installation (--NoFont)."
        return
    }

    Write-Step "Installing $Font Nerd Font (icons support)..."
    try {
        oh-my-posh font install $Font
        Write-Ok "Font installed. Set it in Windows Terminal: '$Font NF' or '$Font Nerd Font'."
    } catch {
        Write-Warn "Font install failed. Install manually: https://www.nerdfonts.com/font-downloads"
    }
}

# ─── Install Theme ───────────────────────────────────────────────────────────
function Install-Theme {
    $themesPath = $env:POSH_THEMES_PATH

    # Fallback: common default paths
    if (-not $themesPath -or -not (Test-Path $themesPath)) {
        $candidates = @(
            "$env:LOCALAPPDATA\Programs\oh-my-posh\themes",
            "$env:LOCALAPPDATA\oh-my-posh\themes",
            "$env:USERPROFILE\.oh-my-posh\themes"
        )
        foreach ($c in $candidates) {
            if (Test-Path $c) { $themesPath = $c; break }
        }
    }

    if (-not $themesPath) {
        # Create one
        $themesPath = "$env:USERPROFILE\.oh-my-posh\themes"
        New-Item -ItemType Directory -Path $themesPath -Force | Out-Null
    }

    $targetPath = Join-Path $themesPath $ThemeFile

    # If running locally (theme folder exists next to script), copy directly
    $localTheme = Join-Path $PSScriptRoot "theme\$ThemeFile"
    if (Test-Path $localTheme) {
        Write-Step "Copying theme from local source..."
        Copy-Item $localTheme $targetPath -Force
    } else {
        Write-Step "Downloading theme from GitHub..."
        try {
            Invoke-WebRequest -Uri $ThemeUrl -OutFile $targetPath -UseBasicParsing
        } catch {
            Write-Fail "Could not download theme. Check your GitHub URL in install.ps1."
            Write-Warn "URL attempted: $ThemeUrl"
            exit 1
        }
    }

    Write-Ok "Theme installed to: $targetPath"
    $script:ThemePath = $targetPath
}

# ─── Update PowerShell Profile ───────────────────────────────────────────────
function Update-Profile {
    if ($NoProfile) {
        Write-Warn "Skipping profile update (--NoProfile)."
        Write-Host "  Add this manually to your `$PROFILE:" -ForegroundColor Gray
        Write-Host "    oh-my-posh init pwsh --config `"$script:ThemePath`" | Invoke-Expression" -ForegroundColor Gray
        return
    }

    # Ensure profile file exists
    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }

    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    $initLine = "oh-my-posh init pwsh --config `"$script:ThemePath`" | Invoke-Expression  # zero-terminal"

    # Remove any old oh-my-posh init lines
    if ($profileContent -match 'oh-my-posh init') {
        Write-Step "Updating existing Oh My Posh config in profile..."
        $profileContent = $profileContent -replace '.*oh-my-posh init.*\n?', ''
        $profileContent = $profileContent.TrimEnd()
        Set-Content $PROFILE $profileContent
    } else {
        Write-Step "Adding Zero Terminal theme to PowerShell profile..."
    }

    # Append the new init line
    Add-Content $PROFILE "`n$initLine"
    Write-Ok "Profile updated: $PROFILE"
}

# ─── Windows Terminal hint ────────────────────────────────────────────────────
function Show-TerminalInstructions {
    $scheme = @'

  Paste this into your Windows Terminal settings.json under "schemes":

  {
    "name": "Zero",
    "background": "#0D1117",
    "foreground": "#E6EDF3",
    "black":        "#21262D", "red":       "#F85149",
    "green":        "#3FB950", "yellow":    "#D29922",
    "blue":         "#58A6FF", "purple":    "#BC8CFF",
    "cyan":         "#39C5CF", "white":     "#B1BAC4",
    "brightBlack":  "#6E7681", "brightRed": "#FF7B72",
    "brightGreen":  "#56D364", "brightYellow": "#E3B341",
    "brightBlue":   "#79C0FF", "brightPurple":  "#D2A8FF",
    "brightCyan":   "#56D364", "brightWhite":   "#F0F6FC",
    "cursorColor": "#58A6FF",  "selectionBackground": "#1F6FEB"
  }

  Then in your profile settings set:
    "colorScheme": "Zero"
    "font": { "face": "CaskaydiaCove Nerd Font", "size": 12 }
    "opacity": 92
    "useAcrylic": true
    "padding": "12"

'@
    Write-Host $scheme -ForegroundColor DarkGray
}

# ─── Complete message ─────────────────────────────────────────────────────────
function Show-Complete {
    Write-Host ""
    Write-Host "  =================================================================" -ForegroundColor Blue
    Write-Host "   Zero Terminal installed!" -ForegroundColor Green
    Write-Host "  =================================================================" -ForegroundColor Blue
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "   1. Restart Windows Terminal (or run: . `$PROFILE)" -ForegroundColor Gray
    Write-Host "   2. Set font to 'CaskaydiaCove Nerd Font' in Windows Terminal" -ForegroundColor Gray
    Write-Host "   3. Apply the Zero color scheme (see below)" -ForegroundColor Gray
    Write-Host ""
    Show-TerminalInstructions
}

# ─── Entry Point ─────────────────────────────────────────────────────────────
Write-Banner

if ($Uninstall) {
    Invoke-Uninstall
    exit 0
}

Install-OhMyPosh
Install-NerdFont
Install-Theme
Update-Profile
Show-Complete
