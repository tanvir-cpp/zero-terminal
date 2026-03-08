# Zero Terminal

A modern, clean, productivity-focused Windows Terminal theme powered by [Oh My Posh](https://ohmyposh.dev/).

## Features

- **GitHub dark color palette** — easy on the eyes, high contrast
- **Smart git status** — branch name, staged/unstaged changes, ahead/behind commits
- **Context-aware language badges** — Python, Node.js, Go, Rust only appear when relevant
- **Execution time** — shown when a command takes longer than 2 seconds
- **Battery indicator** — color-coded (green/yellow/red) with charge state
- **Live clock** — always visible on the right side
- **Two-line prompt** — path info on line 1, clean `❯` cursor on line 2
- **Color-coded exit status** — green `❯` on success, red `✗` on error
- **Transient prompt** — previous prompts collapse to keep scrollback clean

## Prompt Layout

```
 [Windows]  ~/projects/myapp  main * 2  ⎻⎻⎻⎻⎻⎻⎻⎻⎻  ⏱ 3.2s   14:35
 ❯
```

## Install (one command)

> **Before sharing**, replace `YOUR_USERNAME` in `install.ps1` with your GitHub username.

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/zero-terminal/main/install.ps1 | iex
```

That's it. The installer will:

1. Install **Oh My Posh** (via winget, scoop, or the official installer)
2. Install **CaskaydiaCove Nerd Font** (icon support)
3. Copy the theme to your Oh My Posh themes directory
4. Update your `$PROFILE` automatically

Then restart Windows Terminal.

## Manual Install

```powershell
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/zero-terminal.git
cd zero-terminal

# 2. Run the installer
.\install.ps1

# 3. Reload your profile
. $PROFILE
```

## Skip options

```powershell
# Skip font installation (if you already have a Nerd Font)
.\install.ps1 -NoFont

# Skip profile modification
.\install.ps1 -NoProfile
```

## Uninstall

```powershell
.\uninstall.ps1
# or
.\install.ps1 -Uninstall
```

## Windows Terminal Color Scheme

Add this to your `settings.json` under `"schemes"`, then set `"colorScheme": "Zero"` in your profile:

```json
{
  "name": "Zero",
  "background": "#0D1117",
  "foreground": "#E6EDF3",
  "black":        "#21262D",  "red":          "#F85149",
  "green":        "#3FB950",  "yellow":       "#D29922",
  "blue":         "#58A6FF",  "purple":       "#BC8CFF",
  "cyan":         "#39C5CF",  "white":        "#B1BAC4",
  "brightBlack":  "#6E7681",  "brightRed":    "#FF7B72",
  "brightGreen":  "#56D364",  "brightYellow": "#E3B341",
  "brightBlue":   "#79C0FF",  "brightPurple": "#D2A8FF",
  "brightCyan":   "#56D364",  "brightWhite":  "#F0F6FC",
  "cursorColor": "#58A6FF",   "selectionBackground": "#1F6FEB"
}
```

### Recommended Windows Terminal profile settings

```json
{
  "colorScheme": "Zero",
  "font": {
    "face": "CaskaydiaCove Nerd Font",
    "size": 12
  },
  "opacity": 92,
  "useAcrylic": true,
  "padding": "12"
}
```

## Segment Colors

| Segment          | Color     | Description                              |
|------------------|-----------|------------------------------------------|
| Path             | Blue      | Current directory                        |
| Git (clean)      | Green     | Branch is up to date                     |
| Git (dirty)      | Yellow    | Unstaged or staged changes               |
| Git (ahead)      | Blue      | Local commits not pushed                 |
| Git (behind)     | Red       | Remote has commits not pulled            |
| Python           | Purple    | Virtual env or Python version            |
| Node.js          | Green     | Node version (package.json present)      |
| Go               | Cyan      | Go version (go.mod present)              |
| Rust             | Red       | Rust version (Cargo.toml present)        |
| Exec time        | Yellow    | Commands that took more than 2 seconds   |
| Battery          | Green/Red | Battery %, color changes below 50%/20%  |
| Time             | Dim gray  | Current time (HH:MM)                     |
| Prompt `❯`       | Green     | Ready                                    |
| Prompt `✗`       | Red       | Last command failed                      |

## Requirements

- Windows 10 / 11
- Windows Terminal (recommended) or any terminal that supports ANSI
- PowerShell 5.1+ or PowerShell 7+
- Internet connection (for initial install)

## File Structure

```
zero-terminal/
├── README.md
├── install.ps1              # One-command installer
├── uninstall.ps1            # Reverter
├── theme/
│   └── zero.omp.json        # Oh My Posh theme
└── windows-terminal/
    └── zero-scheme.json     # Color scheme (for reference)
```

## License

MIT
