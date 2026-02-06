# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal dotfiles repository for syncing bash and Emacs configuration across multiple machines (Cygwin on Windows, native Linux, WSL). There is no build system, test suite, or linter — this is all shell scripts and Emacs Lisp config files.

## Sync Workflow

The repo uses a "copy in / copy out" pattern with interactive diff-based confirmation:

- **`run.sh`** (from repo root): Orchestrates the full sync — copies local files into the repo (`cp_in`), does `git pull`, then copies repo files back out to the local system (`cp_out`).
- **`move_with_diff.sh`**: Shared helper sourced by all copy scripts. Diffs source vs destination, prompts (y/n) before overwriting. All copy scripts depend on this.
- **`bash/cp_in_bash.sh`**: Copies `~/.bashrc`, `~/.bash_user`, `~/.bash_aliases`, `~/.bash_os`, `~/.bash_color` FROM the local system INTO the repo.
- **`bash/cp_out_bash.sh`**: Copies those files plus `.bash_profile` FROM the repo OUT to `$HOME`.
- **`emacs/cp_in_emacs.sh`**: Copies `~/.emacs` and `~/.emacs.d/*.el` INTO the repo.
- **`emacs/cp_out_emacs.sh`**: Copies them FROM the repo OUT to `$HOME/.emacs.d/`.

All copy scripts must be run from their own directory (they use relative paths like `../move_with_diff.sh` and `.` as dest).

## Bash Config Architecture

`.bashrc` is the entry point and sources these files in order:

1. **`.bash_os`** — Detects OS via `$OSTYPE`, sets `$system` (Windows/Linux), defines OS-specific aliases (e.g., `emacs` invocation differs per OS, Windows gets `cygstart`/`apt-cyg`, Linux gets `xdg-open`/RDP service aliases).
2. **`.bash_aliases`** — Cross-platform aliases (ls, grep, mv/cp/rm safety flags, typo corrections).
3. **`.bash_user`** — User-specific environment (`$EDITOR`, navigation aliases to OneDrive/project paths, project launch commands). On Windows, `.bash_user` lives at `~/OneDrive/.bashrc_user`.
4. **`.bash_color`** — ANSI color variables, PS1 prompt customization (different colors for SSH vs local), LS_COLORS.

The `$system` variable from `.bash_os` is used throughout `.bash_user` to set `$BASEPATH` and `$ONEDRIVE` paths.

## Emacs Config Architecture

`.emacs` loads modular config from `~/.emacs.d/`:
- **`base.el`** — Package management (MELPA), UI settings, backups, ido, helm, projectile, theme (misterioso). This is the main config loaded via `emacs -q -nw --load ~/.emacs.d/base.el`.
- **`code.el`** — Programming-related settings.
- **`lsp.el`** — LSP mode configuration.
- **`custom.el`** — Emacs Custom-generated settings (kept separate).

The Dracula Emacs theme is included as a git submodule at `emacs/.emacs.d/dracula`.

## Future Direction: Symlink-Based Approach

The copy-in/copy-out workflow could be replaced with symlinks (e.g., `ln -sf ~/Documents/GitHub/config/bash/.bashrc ~/.bashrc`). This would eliminate the copy scripts entirely — edits to `~/.bashrc` would be edits to the repo file directly. A one-time `setup.sh` using `ln -sf` would replace the current `cp_out` scripts, and `cp_in` scripts would no longer be needed. The OS-conditional logic in `.bash_os` already handles cross-platform differences so the same tracked files work everywhere.

## Key Details

- Copy scripts source `~/.bash_color` for colorized output, so bash config must be deployed before running emacs copy scripts.
- `emacs/mk_dir.sh` creates `~/.emacs.d/` and `~/.emacs.d/site-lisp/` for fresh installs.
- `run.sh` has a known bug: line 9 calls `./emacs/cp_out_emacs` (missing `.sh` extension).
