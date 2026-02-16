# Deprecated Scripts

This directory contains scripts from the old "copy in / copy out" workflow that was replaced by a symlink-based approach in February 2026.

## Migration Summary

**Old Workflow** (deprecated):
- Configuration files were copied between `$HOME` and the repo
- Required running `cp_in_*.sh` scripts before committing
- Required running `cp_out_*.sh` scripts after pulling
- Easy to forget to sync, leading to conflicts

**New Workflow** (current):
- Configuration files are symlinked from `$HOME` to the repo
- Edits in `$HOME` are automatically edits to the repo
- Just use `git add/commit/push/pull` - no copy scripts needed
- Setup is done once with `./setup.sh`

## Deprecated Scripts

### Root Level
- **move_with_diff.sh** - Shared helper for showing diffs and prompting before overwriting

### Bash Scripts
- **bash/cp_in_bash.sh** - Copied bash configs FROM `$HOME` INTO repo
- **bash/cp_out_bash.sh** - Copied bash configs FROM repo OUT to `$HOME`

### Emacs Scripts
- **emacs/cp_in_emacs.sh** - Copied emacs configs FROM `$HOME` INTO repo
- **emacs/cp_out_emacs.sh** - Copied emacs configs FROM repo OUT to `$HOME`
- **emacs/mk_dir.sh** - Created `~/.emacs.d/` directories for fresh installs

## Migration Date

These scripts were deprecated on **February 10, 2026** with the introduction of `setup.sh`.

## Retention Policy

These scripts are kept as a backup for 6-12 months in case of issues with the symlink approach. They may be deleted after **August 2026**.

## How to Use the New Setup

If you're setting up this repo for the first time or migrating from the old workflow:

```bash
# Preview what will happen
./setup.sh --dry-run

# Interactive setup (prompts for conflicts)
./setup.sh

# Verify setup
./setup.sh --check

# Test
source ~/.bashrc
```

See the main [README.md](../README.md) for complete documentation.

## Emergency Rollback

If you need to temporarily use the old workflow:

1. These scripts still work - they were moved, not modified
2. You can manually copy files:
   ```bash
   # Copy from repo to $HOME (like old cp_out)
   cp bash/.bashrc ~/.bashrc
   cp bash/.bash_user ~/.bash_user
   # ... etc
   ```
3. Or run the old scripts from this directory:
   ```bash
   cd deprecated/bash
   ./cp_out_bash.sh
   ```

However, the symlink approach is recommended - it's simpler and less error-prone.
