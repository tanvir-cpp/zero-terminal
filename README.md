# Zero Terminal

A modern, clean, productivity-focused terminal theme powered by [Oh My Posh](https://ohmyposh.dev/). Works on Windows, macOS, and Linux.

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
 [OS]  ~/projects/myapp  main * 2  ⎻⎻⎻⎻⎻⎻⎻⎻⎻  ⏱ 3.2s   14:35
 ❯
```

## Install (one command)

### Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/tanvir-cpp/zero-terminal/main/install.ps1 | iex
```

The installer will:
1. Install **Oh My Posh** (via winget, scoop, or the official installer)
2. Install **CaskaydiaCove Nerd Font** (icon support)
3. Copy the theme to your Oh My Posh themes directory
4. Update your `$PROFILE` automatically

Then restart Windows Terminal.

### macOS / Linux

Open your terminal and run:

```bash
bash <(curl -s https://raw.githubusercontent.com/tanvir-cpp/zero-terminal/main/install.sh)
```

The installer will:
1. Install **Oh My Posh** (via Homebrew on macOS, or official script on Linux)
2. Install **CaskaydiaCove Nerd Font** (icon support)
3. Copy the theme to `~/.config/oh-my-posh/themes/`
4. Update your `~/.zshrc` or `~/.bashrc` automatically

Then restart your terminal.

## Manual Install

### Windows

```powershell
# 1. Clone the repo
git clone https://github.com/tanvir-cpp/zero-terminal.git
cd zero-terminal

# 2. Run the installer
.\install.ps1

# 3. Reload your profile
. $PROFILE
```

### macOS / Linux

```bash
# 1. Clone the repo
git clone https://github.com/tanvir-cpp/zero-terminal.git
cd zero-terminal

# 2. Run the installer
bash install.sh

# 3. Reload your profile
source ~/.zshrc
```

## Options

### Windows

```powershell
.\install.ps1 -NoFont      # Skip font installation
.\install.ps1 -NoProfile   # Skip profile modification
.\install.ps1 -Uninstall   # Remove Zero Terminal
```

### macOS / Linux

```bash
bash install.sh --no-font      # Skip font installation
bash install.sh --no-profile   # Skip profile modification
bash install.sh --uninstall    # Remove Zero Terminal
```

## Uninstall

### Windows
```powershell
.\uninstall.ps1
```

### macOS / Linux
```bash
bash install.sh --uninstall
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

| Platform | Requirements |
|----------|-------------|
| Windows  | Windows 10/11, PowerShell 5.1+, Windows Terminal |
| macOS    | macOS 10.15+, zsh or bash, any terminal |
| Linux    | zsh or bash, any terminal with ANSI support |

All platforms require an internet connection for initial install.

## File Structure

```
zero-terminal/
├── README.md
├── install.ps1              # Windows installer
├── install.sh               # macOS/Linux installer
├── uninstall.ps1            # Windows reverter
├── theme/
│   └── zero.omp.json        # Oh My Posh theme
└── windows-terminal/
    └── zero-scheme.json     # Windows Terminal color scheme
```

## License

MIT
