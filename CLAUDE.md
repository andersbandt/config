# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal dotfiles repository for syncing bash and Emacs configuration across multiple machines (Cygwin on Windows, native Linux, WSL). Configuration files are symlinked from `$HOME` to the repo, so edits in either location are immediately reflected. There is no build system, test suite, or linter — this is all shell scripts and Emacs Lisp config files.

## Setup & Installation

### Fresh Install

1. **Clone the repository**:
   ```bash
   git clone <repo-url> ~/Documents/GitHub/config
   cd ~/Documents/GitHub/config
   ```

2. **Preview setup** (see what will happen):
   ```bash
   ./setup.sh --dry-run
   ```

3. **Run setup** (interactive - prompts for conflicts):
   ```bash
   ./setup.sh
   ```
   - Script detects existing files and shows diffs
   - Prompts for each conflict: `[s]ymlink (backup existing), [k]eep, [a]bort`
   - Creates timestamped backups before overwriting

4. **Verify** (check all symlinks are correct):
   ```bash
   ./setup.sh --check
   ```

5. **Test**:
   ```bash
   source ~/.bashrc
   emacs --version
   ```

### Setup Options

- `--bash-only` - Only setup bash configurations
- `--emacs-only` - Only setup emacs configurations
- `--dry-run` - Show what would happen without making changes
- `--force` - Skip prompts, backup and overwrite existing files
- `--check` - Validate existing symlinks without making changes
- `--help` - Show usage information

### Update Workflow

Since configuration files are symlinked, the workflow is simple:

1. **Make edits** (edit in `$HOME` or directly in the repo - they're the same):
   ```bash
   emacs ~/.bashrc       # Edits repo/bash/.bashrc directly!
   emacs ~/.emacs.d/base.el   # Edits repo/emacs/.emacs.d/base.el directly!
   ```

2. **Commit changes**:
   ```bash
   cd ~/Documents/GitHub/config
   git add bash/.bashrc
   git commit -m "Updated bash aliases"
   git push
   ```

3. **Sync on another machine**:
   ```bash
   cd ~/Documents/GitHub/config
   git pull
   # Changes are immediately live via symlinks!
   source ~/.bashrc  # Only needed if bash config changed
   ```

## Bash Config Architecture

Configuration files are symlinked from `bash/` in the repo to `$HOME`:

```
$REPO_ROOT/bash/.bashrc        -> $HOME/.bashrc
$REPO_ROOT/bash/.bash_profile  -> $HOME/.bash_profile
$REPO_ROOT/bash/.bash_user     -> $HOME/.bash_user
$REPO_ROOT/bash/.bash_aliases  -> $HOME/.bash_aliases
$REPO_ROOT/bash/.bash_os       -> $HOME/.bash_os
$REPO_ROOT/bash/.bash_color    -> $HOME/.bash_color
```

`.bashrc` is the entry point and sources these files in order:

1. **`.bash_os`** — Detects OS via `$OSTYPE`, sets `$system` (Windows/Linux/WSL), defines OS-specific aliases (e.g., `emacs` invocation differs per OS, Windows gets `cygstart`/`apt-cyg`, Linux gets `xdg-open`/RDP service aliases).
2. **`.bash_aliases`** — Cross-platform aliases (ls, grep, mv/cp/rm safety flags, typo corrections).
3. **`.bash_user`** — User-specific environment (`$EDITOR`, navigation aliases to OneDrive/project paths, project launch commands).
4. **`.bash_color`** — ANSI color variables, PS1 prompt customization (different colors for SSH vs local), LS_COLORS.

The `$system` variable from `.bash_os` is used throughout `.bash_user` to set `$BASEPATH` and `$ONEDRIVE` paths.

## Emacs Config Architecture

Configuration files are symlinked from `emacs/` in the repo to `$HOME`:

```
$REPO_ROOT/emacs/.emacs     -> $HOME/.emacs
$REPO_ROOT/emacs/.emacs.d/  -> $HOME/.emacs.d/
```

`.emacs` loads modular config from `~/.emacs.d/`:
- **`base.el`** — Package management (MELPA), UI settings, backups, ido, helm, projectile, theme (misterioso). This is the main config loaded via `emacs -q -nw --load ~/.emacs.d/base.el`.
- **`code.el`** — Programming-related settings.
- **`lsp.el`** — LSP mode configuration.
- **`custom.el`** — Emacs Custom-generated settings (kept separate).
- **`org.el`** — Org-mode configuration.
- **`obsidian.el`** — Obsidian integration.

The Dracula Emacs theme is included as a git submodule at `emacs/.emacs.d/dracula`.

**Note**: Machine-specific state files (`ido.last`, `elgrep-data.el`) are excluded via `.gitignore` to prevent cross-machine conflicts.

## Machine-Local Overrides

Shared config needs per-machine escape hatches for things like "enable heavy feature X here but not there". The repo uses a gitignored override file pattern.

### Emacs: `~/.emacs.d/local.el`

- Loaded near the top of `base.el` (right after `custom.el`), before any feature gate reads the flags it sets.
- Gitignored (`.gitignore` entry: `emacs/.emacs.d/local.el`).
- Missing file is fine — `(load ... 'noerror 'nomessage)`.

Current flags (extend as needed):

| Flag | Default | Purpose |
|---|---|---|
| `my-obsidian-enabled` | `nil` | Load and activate obsidian.el. Off by default because the initial vault scan is slow on WSL's 9P mount. |

Example `~/.emacs.d/local.el`:

```elisp
(setq my-obsidian-enabled t)
```

### Bash: `~/.bash_local` (planned)

The same pattern for shell config (sourced at the end of `.bashrc` if present) is listed in the Roadmap below but not yet implemented. When added, it should follow the same conventions: gitignored, guarded load, feature-flag style.

### When to use local.el vs. OS detection

- **OS detection** (`my--wsl-p`, `$system` in bash) → behavior that's *deterministically* different between platforms (e.g., "the vault lives at `/mnt/c/...` on WSL but `~/` on Windows"). Lives in the shared config.
- **local.el** → behavior that varies between *same-OS* machines based on taste, hardware speed, or what's installed (e.g., "this laptop is too slow for obsidian indexing"). Lives per-machine.

## Cross-Platform Support

The same configuration files work across all platforms thanks to conditional logic in `.bash_os`:

- **Linux** (native) - Detected via `$OSTYPE`
- **WSL** (Windows Subsystem for Linux) - Detected via `/proc/version`
- **Cygwin** (Windows) - Detected via `$OSTYPE`

Platform-specific behavior (file paths, command aliases) is handled by the `$system` variable set in `.bash_os`.

## Backup Scripts

The `backup/` directory contains automated backup scripts and systemd units:

- **`backup.sh`** — Full-system backup for Ubuntu desktop. Creates a bzip2-compressed tarball of `/` to an external HDD at `/mnt/backdrive_1/backup`. Excludes `~/Pictures` and `~/.cache`. Auto-deletes backups older than 2 weeks.
- **`backup-pi.sh`** — Lightweight Raspberry Pi backup. Backs up `/home/pi`, system configs (`/etc/systemd/system`, cron, fstab, hosts, network, apt sources), and `/opt` to a USB drive at `/mnt/usb/backup`.
- **`checksums.sh`** — Generate and verify SHA256 checksums for files in a directory. Two modes: `checksums.sh [DIR] [OUTPUT]` to generate, `checksums.sh --verify FILE [DIR]` to verify. Useful for detecting file corruption in backups and archives.
- **`backup.service`** — systemd oneshot service that runs `backup.sh`.
- **`backup.timer`** — systemd timer that triggers the backup monthly. Uses `Persistent=true` (catches up after missed runs) and `RandomizedDelaySec=1h`.

These scripts are standalone (not symlinked anywhere). To install the systemd timer, copy the `.service` and `.timer` files to `/etc/systemd/system/` and enable with `systemctl enable --now backup.timer`.

**Note**: The `backup.service` currently references `ExecStart=/home/anders/Code/bash/backup.sh` — this path may need updating to point to the repo location.

## Key Files

### Setup Script
- **`setup.sh`** — One-time setup script that creates all symlinks. Run on fresh install or to verify existing setup.

### Configuration Files
- **Bash**: `.bashrc`, `.bash_profile`, `.bash_user`, `.bash_aliases`, `.bash_os`, `.bash_color`
- **Emacs**: `.emacs`, `.emacs.d/` (entire directory including all `.el` files and themes)
- **Backup**: `backup.sh`, `backup-pi.sh`, `checksums.sh`, `backup.service`, `backup.timer`

### Documentation
- **`CLAUDE.md`** — This file (instructions for Claude Code)
- **`README.md`** — User-facing documentation
- **`deprecated/README.md`** — Information about old copy-based workflow

## Verification

To check that all symlinks are correctly configured:

```bash
./setup.sh --check
```

This validates:
- All expected symlinks exist
- They point to the correct targets in the repo
- No broken or missing symlinks

## In-Progress / Known Issues

### Python LSP (pylsp) — NOT WORKING as of Feb 2026

Attempted to get Python code completion via `lsp-mode` + `pylsp`. Current state:

- `pylsp` is installed at `C:/Users/ander/AppData/Local/Programs/Python/Python312/Scripts/pylsp.exe`
- `lsp-mode` is installed and loads
- `lsp-pylsp-server-command` is set to the full path in `lsp.el` (Windows only)
- LSP still shows **disconnected** when opening a `.py` file
- `lsp-workspace-show-log` shows "IO MESSAGES DISABLED" — enable with `(setq lsp-log-io t)` before diagnosing

**Next debugging steps:**
1. Enable `(setq lsp-log-io t)`, restart Emacs, open `.py` file, then check `M-x lsp-workspace-show-log`
2. Try running pylsp manually from a cmd prompt to see if it errors on startup
3. May be a Cygwin vs native Windows Python mismatch — pylsp was installed via Cygwin pip but Windows Emacs runs it as a native process

---

## Roadmap / Future Improvements

Discussed Feb 2026. Pick these up in future sessions.

### Quick Wins
- **Git config** — Track `.gitconfig` and `.gitignore_global` in the repo (aliases, editor, default branch, diff tool). Add to `setup.sh` symlinks.
- **SSH config** — Track `~/.ssh/config` (host aliases, jump hosts, key mappings). Keys stay out, config is safe to track.
- **Machine-local overrides (bash half)** — Add a `~/.bash_local` sourced at the end of `.bashrc`, gitignored, for per-machine settings that shouldn't be shared. The Emacs half of this pattern is already implemented (`~/.emacs.d/local.el`, see "Machine-Local Overrides" section above) — mirror its conventions.

### New Machine Bootstrap
- **Package list bootstrap** — Keep a curated essentials list in the repo. Have `setup.sh` offer to install them (`apt`, `snap`, `flatpak`). Builds on the package lists already saved in `backup.sh`.
- **`setup.sh` dependency check** — Before symlinking, detect missing dependencies (emacs, git, curl, etc.) and offer to install them.
- **Post-install checklist** — A markdown file of manual steps that can't be automated (browser login, SSH key gen, GitHub auth).

### Windows Coverage
- **Windows package list** — `winget export` or scoop manifest for reproducible installs. Could live in a `windows/` directory.
- **Windows config files** — Windows Terminal settings, PowerShell profile, VS Code `settings.json`/extensions list. Symlinked or copied via a PowerShell setup script.

### Backup Rework
- **Slim down `backup.sh`** — The full `/` tarball is 35GB+ and not practically restorable for bare-metal recovery. Rework to only back up lightweight system configs (`/etc`, crontabs, systemd units, `/opt`) + package lists. Deja Dup already handles `$HOME` to a separate HDD. Model it after `backup-pi.sh` which already takes this approach.
- **Current `backup.sh` excludes for reference** — Pictures, .cache, ncs/downloads, var/cache, var/log, var/tmp, snapd, flatpak, docker, Steam.

### Longer Term
- **Cron/systemd inventory** — Track any custom crontabs or systemd services beyond the backup timer.
- **Emacs package pinning** — Pin MELPA package versions so installs are reproducible across machines (`use-package :pin` or lockfile approach).

---

## Legacy Workflow (Deprecated)

**Prior to February 2026**, this repo used a "copy in / copy out" workflow with separate bash scripts:
- `cp_in_*.sh` - Copied files FROM `$HOME` INTO the repo (before committing)
- `cp_out_*.sh` - Copied files FROM the repo OUT to `$HOME` (after pulling)
- `move_with_diff.sh` - Shared helper for diffing and prompting

This workflow was error-prone (easy to forget to run scripts) and has been replaced by symlinks.

**Legacy scripts location**: `deprecated/` directory (retained for 6-12 months as emergency fallback, may be deleted after August 2026).

**Migration date**: February 10, 2026

See `deprecated/README.md` for details on the old workflow and emergency rollback procedures if needed.
