# config

A personal dotfiles repository for syncing bash, Emacs, and backup configuration across multiple machines (Cygwin on Windows, native Linux, WSL). Configuration files are symlinked from `$HOME` to the repo, so edits in either location are immediately reflected.

## Quick Start

```bash
git clone <repo-url> ~/Documents/GitHub/config
cd ~/Documents/GitHub/config
./setup.sh --dry-run   # preview what will happen
./setup.sh             # interactive setup (prompts for conflicts)
./setup.sh --check     # verify symlinks afterward
```

See `./setup.sh --help` for all options (`--bash-only`, `--emacs-only`, `--force`, etc.).

## Contents

### bash

Shell configuration files, symlinked to `$HOME`:

| File | Purpose |
|------|---------|
| `.bashrc` | Entry point, sources all other files |
| `.bash_profile` | Login shell setup |
| `.bash_os` | OS detection (`$system`), platform-specific aliases |
| `.bash_aliases` | Cross-platform aliases (ls, grep, safety flags) |
| `.bash_user` | User environment (`$EDITOR`, navigation aliases, project paths) |
| `.bash_color` | ANSI colors, PS1 prompt, LS_COLORS |

### emacs

Emacs configuration, symlinked to `$HOME`:

| File | Purpose |
|------|---------|
| `.emacs` | Entry point, loads modular config from `.emacs.d/` |
| `.emacs.d/base.el` | Package management (MELPA), UI, ido, helm, projectile, theme |
| `.emacs.d/code.el` | Programming settings |
| `.emacs.d/lsp.el` | LSP mode configuration |
| `.emacs.d/custom.el` | Emacs Custom-generated settings |
| `.emacs.d/org.el` | Org-mode configuration |
| `.emacs.d/obsidian.el` | Obsidian integration |

The Dracula theme is included as a git submodule at `emacs/.emacs.d/dracula`.

### backup

Automated backup scripts for Ubuntu desktop and Raspberry Pi.

#### Ubuntu Desktop (`backup.sh`)

Monthly full-system backup to an external HDD:

- Creates a bzip2-compressed tarball of the entire system
- Excludes `~/Pictures` and `~/.cache`
- Auto-deletes backups older than 2 weeks
- Checks that the backup drive is mounted at `/mnt/backdrive_1` before running

**Installation** (systemd timer):

```bash
sudo cp backup.service /etc/systemd/system/
sudo cp backup.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
```

**Managing the timer:**

```bash
systemctl status backup.timer          # check status
systemctl list-timers | grep backup    # list timers
sudo systemctl start backup.service    # run manually
journalctl -u backup.service           # view logs
sudo systemctl disable --now backup.timer  # disable
```

The timer uses `Persistent=true` (catches up after missed runs) and `RandomizedDelaySec=1h` to avoid running immediately at boot.

#### Raspberry Pi (`backup-pi.sh`)

Lightweight backup of home directory and system configs to a USB drive:

- `/home/pi` -- user files
- `/etc/systemd/system` -- custom services
- `/etc/cron.d`, `/etc/crontab` -- scheduled jobs
- `/etc/fstab`, `/etc/hosts`, `/etc/hostname` -- system identity
- `/etc/network`, `/etc/wpa_supplicant` -- network/wifi config
- `/etc/apt/sources.list.d` -- custom apt repos
- `/opt` -- manually installed software

**Setup on Pi:**

```bash
scp backup-pi.sh pi@<pi-ip>:~/
chmod +x ~/backup-pi.sh
sudo ./backup-pi.sh   # test run
```

**Schedule with anacron** (recommended for Pis that get powered off):

```bash
# Add to /etc/anacrontab
@monthly 10 pi-backup /home/pi/backup-pi.sh
```

**Restoring:**

```bash
sudo tar xzvf pi-backup-2024-01-15.tar.gz -C /           # everything
sudo tar xzvf pi-backup-2024-01-15.tar.gz -C / home/pi    # specific paths
```

#### Checksum Verification (`checksums.sh`)

Generate SHA256 checksums for files in a directory, then verify them later to detect corruption.

**Generate checksums:**

```bash
./backup/checksums.sh ~/Photos                          # writes ./checksums.sha256
./backup/checksums.sh ~/Photos ~/Photos/checksums.sha256  # custom output location
```

**Verify checksums:**

```bash
./backup/checksums.sh --verify checksums.sha256           # verify from current dir
./backup/checksums.sh --verify checksums.sha256 ~/Photos  # verify against specific dir
```

Paths are stored relative to the source directory, so the checksum file is portable. Exits non-zero if any files are missing or corrupted.

## Update Workflow

Since config files are symlinked, edits in `$HOME` are already edits in the repo:

```bash
emacs ~/.bashrc                  # edits repo/bash/.bashrc directly
cd ~/Documents/GitHub/config
git add bash/.bashrc && git commit -m "Updated aliases" && git push
```

On another machine:

```bash
cd ~/Documents/GitHub/config && git pull
source ~/.bashrc   # only needed if bash config changed
```

## Cross-Platform Support

The same configuration works across Linux, WSL, and Cygwin via conditional logic in `.bash_os`. The `$system` variable drives platform-specific paths and aliases.

## Legacy Workflow

Prior to February 2026, this repo used copy-in/copy-out scripts instead of symlinks. Those scripts are preserved in the `deprecated/` directory. See `deprecated/README.md` for details.
