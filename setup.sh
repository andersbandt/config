#!/usr/bin/env bash

# setup.sh - Symlink-based dotfiles setup script
# Creates symlinks from $HOME to repo configuration files

set -e  # Exit on error

#############################
#### GLOBAL VARIABLES    ####
#############################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
DRY_RUN=false
FORCE=false
CHECK_ONLY=false
BASH_ONLY=false
EMACS_ONLY=false

# Will be populated by source_colors()
RED=""
GREEN=""
YELLOW=""
BLUE=""
CYAN=""
ENDC=""

#############################
#### HELPER FUNCTIONS    ####
#############################

detect_repo_root() {
    # Already set by SCRIPT_DIR, but validate it's a git repo
    if [[ ! -d "$REPO_ROOT/.git" ]]; then
        echo "ERROR: Not in a git repository. Expected .git directory at $REPO_ROOT"
        exit 1
    fi
}

source_colors() {
    # Define colors directly — don't source .bash_color, whose base color
    # variables intentionally omit the closing 'm' (for use with LS_COLORS
    # and PS1 in a different way), which would break echo -e usage here.
    RED='\033[00;31m'
    GREEN='\033[00;32m'
    YELLOW='\033[00;33m'
    BLUE='\033[00;34m'
    CYAN='\033[00;36m'
    ENDC='\033[0m'
}

detect_os() {
    # Source OS detection if needed
    local os_file="$REPO_ROOT/bash/.bash_os"
    if [[ -f "$os_file" ]]; then
        source "$os_file" 2>/dev/null || true
    fi

    # Fallback detection
    if [[ -z "$system" ]]; then
        case "$OSTYPE" in
            linux*|cygwin*)
                if grep -qi microsoft /proc/version 2>/dev/null; then
                    system="WSL"
                elif [[ "$OSTYPE" == "cygwin" ]]; then
                    system="Windows"
                else
                    system="Linux"
                fi
                ;;
            *)
                system="Unknown"
                ;;
        esac
    fi

    echo -e "${CYAN}Detected OS: $system${ENDC}"
}

show_diff() {
    local existing_file="$1"
    local repo_file="$2"

    echo -e "\n${YELLOW}Differences between existing file and repo version:${ENDC}"
    echo -e "${CYAN}Existing:${ENDC} $existing_file"
    echo -e "${CYAN}Repo:${ENDC}     $repo_file"
    echo ""

    if diff --strip-trailing-cr --color=always "$existing_file" "$repo_file" 2>/dev/null || true; then
        echo -e "${GREEN}Files are identical${ENDC}"
        return 0
    else
        echo -e "\n${RED}(RED lines will be eliminated if you choose to symlink)${ENDC}"
        return 1
    fi
}

prompt_action() {
    local file="$1"
    local action_msg="${2:-Create symlink}"

    echo -e "\n${YELLOW}Action required for: $file${ENDC}"
    echo -e "${CYAN}[s]${ENDC}ymlink (backup existing), ${CYAN}[k]${ENDC}eep existing, ${CYAN}[a]${ENDC}bort"
    read -r -p "Choice: " choice

    case "$choice" in
        s|S|symlink)
            return 0  # Proceed with symlink
            ;;
        k|K|keep)
            return 1  # Keep existing
            ;;
        a|A|abort)
            echo -e "${RED}Aborted by user${ENDC}"
            exit 1
            ;;
        *)
            echo -e "${RED}Invalid choice, keeping existing file${ENDC}"
            return 1
            ;;
    esac
}

backup_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return 0  # Nothing to backup
    fi

    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local backup="${file}.backup.${timestamp}"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${BLUE}[DRY-RUN]${ENDC} Would backup: $file -> $backup"
        return 0
    fi

    cp -a "$file" "$backup"
    echo -e "${GREEN}✓${ENDC} Backed up: $backup"
}

create_symlink() {
    local target="$1"   # File in repo
    local link="$2"     # Symlink location in $HOME

    # Validate target exists
    if [[ ! -e "$target" ]] && [[ ! -d "$target" ]]; then
        echo -e "${RED}✗${ENDC} Target does not exist: $target"
        return 1
    fi

    # Create parent directory if needed
    local parent_dir="$(dirname "$link")"
    if [[ ! -d "$parent_dir" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${BLUE}[DRY-RUN]${ENDC} Would create directory: $parent_dir"
        else
            mkdir -p "$parent_dir"
            echo -e "${GREEN}✓${ENDC} Created directory: $parent_dir"
        fi
    fi

    # Check if link already exists and is correct
    if [[ -L "$link" ]]; then
        local current_target="$(readlink "$link")"
        if [[ "$current_target" == "$target" ]]; then
            echo -e "${GREEN}✓${ENDC} Already linked: $link -> $target"
            return 0
        else
            echo -e "${YELLOW}⚠${ENDC} Symlink exists but points to wrong target"
            echo -e "  Current: $link -> $current_target"
            echo -e "  Expected: $link -> $target"

            if [[ "$FORCE" == false ]] && [[ "$DRY_RUN" == false ]]; then
                if ! prompt_action "$link" "Relink"; then
                    return 0  # User chose to keep existing
                fi
            fi

            if [[ "$DRY_RUN" == true ]]; then
                echo -e "${BLUE}[DRY-RUN]${ENDC} Would remove old symlink and create new one"
                return 0
            fi

            rm "$link"
        fi
    elif [[ -e "$link" ]] || [[ -d "$link" ]]; then
        # Regular file or directory exists
        echo -e "${YELLOW}⚠${ENDC} File exists: $link"

        # Show diff if it's a regular file
        if [[ -f "$link" ]] && [[ -f "$target" ]]; then
            show_diff "$link" "$target"
        fi

        if [[ "$FORCE" == false ]] && [[ "$DRY_RUN" == false ]]; then
            if ! prompt_action "$link"; then
                return 0  # User chose to keep existing
            fi
        fi

        # Backup and remove existing file
        backup_file "$link"

        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${BLUE}[DRY-RUN]${ENDC} Would remove: $link"
        else
            rm -rf "$link"
        fi
    fi

    # Create the symlink
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${BLUE}[DRY-RUN]${ENDC} Would create symlink: $link -> $target"
    else
        ln -sf "$target" "$link"
        echo -e "${GREEN}✓${ENDC} Created symlink: $link -> $target"
    fi
}

verify_symlink() {
    local link="$1"
    local expected_target="$2"

    if [[ ! -L "$link" ]]; then
        echo -e "${RED}✗${ENDC} Not a symlink: $link"
        return 1
    fi

    if [[ ! -e "$link" ]]; then
        echo -e "${RED}✗${ENDC} Broken symlink: $link"
        return 1
    fi

    local actual_target="$(readlink "$link")"
    if [[ "$actual_target" != "$expected_target" ]]; then
        echo -e "${RED}✗${ENDC} Wrong target: $link"
        echo -e "  Expected: $expected_target"
        echo -e "  Actual:   $actual_target"
        return 1
    fi

    echo -e "${GREEN}✓${ENDC} Valid: $link -> $expected_target"
    return 0
}

#############################
#### SETUP FUNCTIONS     ####
#############################

setup_bash() {
    echo -e "\n${CYAN}=== Setting up Bash configuration ===${ENDC}\n"

    local bash_files=(
        ".bashrc"
        ".bash_profile"
        ".bash_user"
        ".bash_aliases"
        ".bash_os"
        ".bash_color"
    )

    for file in "${bash_files[@]}"; do
        create_symlink "$REPO_ROOT/bash/$file" "$HOME/$file"
    done

    echo -e "\n${GREEN}Bash setup complete${ENDC}"
}

setup_emacs() {
    echo -e "\n${CYAN}=== Setting up Emacs configuration ===${ENDC}\n"

    # Symlink .emacs
    create_symlink "$REPO_ROOT/emacs/.emacs" "$HOME/.emacs"

    # .emacs.d must be a real directory (not a symlink) so that packages
    # and runtime state (elpa/, ido.last, etc.) live locally per machine.
    # Only the config .el files are symlinked into it.
    if [[ -L "$HOME/.emacs.d" ]]; then
        echo -e "${YELLOW}⚠${ENDC} $HOME/.emacs.d is a symlink — replacing with real directory"
        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${BLUE}[DRY-RUN]${ENDC} Would remove symlink and create directory: $HOME/.emacs.d"
        else
            rm "$HOME/.emacs.d"
            mkdir -p "$HOME/.emacs.d"
            echo -e "${GREEN}✓${ENDC} Created directory: $HOME/.emacs.d"
        fi
    elif [[ ! -d "$HOME/.emacs.d" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${BLUE}[DRY-RUN]${ENDC} Would create directory: $HOME/.emacs.d"
        else
            mkdir -p "$HOME/.emacs.d"
            echo -e "${GREEN}✓${ENDC} Created directory: $HOME/.emacs.d"
        fi
    else
        echo -e "${GREEN}✓${ENDC} Directory exists: $HOME/.emacs.d"
    fi

    # Symlink individual config .el files.
    # elgrep-data.el is intentionally excluded (machine-specific runtime state).
    local emacs_el_files=(
        "base.el"
        "code.el"
        "custom.el"
        "lsp.el"
        "obsidian.el"
        "org.el"
    )

    for file in "${emacs_el_files[@]}"; do
        create_symlink "$REPO_ROOT/emacs/.emacs.d/$file" "$HOME/.emacs.d/$file"
    done

    # On Windows/Cygwin, copy the AppData bootstrap file if APPDATA is set.
    # Native Windows Emacs loads from AppData/Roaming/.emacs — can't use symlinks.
    if [[ "$system" == "Windows" ]] && [[ -n "$APPDATA" ]]; then
        local appdata_unix
        appdata_unix="$(cygpath -u "$APPDATA")"
        local dest="$appdata_unix/.emacs"
        local src="$REPO_ROOT/emacs/windows-appdata-init.el"

        if [[ "$DRY_RUN" == true ]]; then
            echo -e "${BLUE}[DRY-RUN]${ENDC} Would copy Windows bootstrap: $src -> $dest"
        else
            cp "$src" "$dest"
            echo -e "${GREEN}✓${ENDC} Copied Windows bootstrap: $dest"
            echo -e "${YELLOW}  Edit my-emacs-repo/HOME paths in $dest if needed${ENDC}"
        fi
    fi

    # Notify about per-machine overrides. The file itself is gitignored and
    # must be created per-machine — setup.sh intentionally does NOT create it.
    # See "Machine-Local Overrides" section in CLAUDE.md for details.
    local local_el="$HOME/.emacs.d/local.el"
    echo ""
    echo -e "${CYAN}Per-machine overrides:${ENDC} $local_el"
    if [[ -f "$local_el" ]] && [[ ! -L "$local_el" ]]; then
        echo -e "${GREEN}  ✓ exists (gitignored, per-machine flags active)${ENDC}"
    else
        echo -e "${YELLOW}  not present — create it to opt into heavy features.${ENDC}"
        echo -e "${YELLOW}  Example: (setq my-obsidian-enabled t)${ENDC}"
    fi

    echo -e "\n${GREEN}Emacs setup complete${ENDC}"
}

check_all_symlinks() {
    echo -e "\n${CYAN}=== Verifying symlink configuration ===${ENDC}\n"

    local all_valid=true

    # Check bash symlinks
    if [[ "$EMACS_ONLY" == false ]]; then
        echo -e "${YELLOW}Bash configuration:${ENDC}"
        local bash_files=(".bashrc" ".bash_profile" ".bash_user" ".bash_aliases" ".bash_os" ".bash_color")
        for file in "${bash_files[@]}"; do
            if ! verify_symlink "$HOME/$file" "$REPO_ROOT/bash/$file"; then
                all_valid=false
            fi
        done
    fi

    # Check emacs symlinks
    if [[ "$BASH_ONLY" == false ]]; then
        echo -e "\n${YELLOW}Emacs configuration:${ENDC}"
        if ! verify_symlink "$HOME/.emacs" "$REPO_ROOT/emacs/.emacs"; then
            all_valid=false
        fi

        # .emacs.d should be a real directory, not a symlink
        if [[ -L "$HOME/.emacs.d" ]]; then
            echo -e "${RED}✗${ENDC} Should be a real directory (not a symlink): $HOME/.emacs.d"
            all_valid=false
        elif [[ -d "$HOME/.emacs.d" ]]; then
            echo -e "${GREEN}✓${ENDC} Directory exists: $HOME/.emacs.d"
        else
            echo -e "${RED}✗${ENDC} Missing directory: $HOME/.emacs.d"
            all_valid=false
        fi

        local emacs_el_files=("base.el" "code.el" "custom.el" "lsp.el" "obsidian.el" "org.el")
        for file in "${emacs_el_files[@]}"; do
            if ! verify_symlink "$HOME/.emacs.d/$file" "$REPO_ROOT/emacs/.emacs.d/$file"; then
                all_valid=false
            fi
        done
    fi

    echo ""
    if [[ "$all_valid" == true ]]; then
        echo -e "${GREEN}✓ All symlinks valid${ENDC}"
        return 0
    else
        echo -e "${RED}✗ Some symlinks invalid or missing${ENDC}"
        echo -e "${YELLOW}Run './setup.sh' to fix${ENDC}"
        return 1
    fi
}

#############################
#### MAIN FUNCTION       ####
#############################

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Symlink-based dotfiles setup script for bash and emacs configurations.

OPTIONS:
    --bash-only     Only setup bash configurations
    --emacs-only    Only setup emacs configurations
    --dry-run       Show what would happen without making changes
    --force         Skip prompts, backup and overwrite existing files
    --check         Validate existing symlinks without making changes
    --help          Show this help message

EXAMPLES:
    $0                  # Interactive setup (prompts for conflicts)
    $0 --dry-run        # Preview what would happen
    $0 --check          # Verify existing symlinks
    $0 --bash-only      # Only setup bash configs
    $0 --force          # Automatic setup (backup and overwrite)

WORKFLOW:
    1. First run:   ./setup.sh --dry-run    (preview)
    2. Setup:       ./setup.sh              (interactive)
    3. Verify:      ./setup.sh --check      (validate)

After setup, edit files in \$HOME or the repo - they're the same via symlinks!
EOF
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --bash-only)
                BASH_ONLY=true
                shift
                ;;
            --emacs-only)
                EMACS_ONLY=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --check)
                CHECK_ONLY=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Validate mutually exclusive flags
    if [[ "$BASH_ONLY" == true ]] && [[ "$EMACS_ONLY" == true ]]; then
        echo "ERROR: --bash-only and --emacs-only are mutually exclusive"
        exit 1
    fi

    # Initialize
    source_colors
    detect_repo_root

    echo -e "${CYAN}╔════════════════════════════════════════╗${ENDC}"
    echo -e "${CYAN}║   Dotfiles Setup - Symlink Mode       ║${ENDC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${ENDC}"
    echo ""
    echo -e "${CYAN}Repo root:${ENDC} $REPO_ROOT"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${BLUE}Mode: DRY-RUN (no changes will be made)${ENDC}"
    fi

    if [[ "$FORCE" == true ]]; then
        echo -e "${YELLOW}Mode: FORCE (auto-backup and overwrite)${ENDC}"
    fi

    detect_os

    # Check mode - just validate and exit
    if [[ "$CHECK_ONLY" == true ]]; then
        check_all_symlinks
        exit $?
    fi

    # Setup mode
    if [[ "$EMACS_ONLY" == false ]]; then
        setup_bash
    fi

    if [[ "$BASH_ONLY" == false ]]; then
        setup_emacs
    fi

    # Summary
    echo -e "\n${CYAN}╔════════════════════════════════════════╗${ENDC}"
    echo -e "${CYAN}║   Setup Complete                       ║${ENDC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${ENDC}"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "\n${BLUE}This was a dry-run. Run without --dry-run to apply changes.${ENDC}"
    else
        echo -e "\n${GREEN}✓${ENDC} Dotfiles are now symlinked to the repo"
        echo -e "${GREEN}✓${ENDC} Edit files in \$HOME or repo - they're the same!"
        echo -e "\nNext steps:"
        echo -e "  1. Verify: ${CYAN}./setup.sh --check${ENDC}"
        echo -e "  2. Test:   ${CYAN}source ~/.bashrc${ENDC}"
        echo -e "  3. Commit: ${CYAN}git add . && git commit${ENDC}"
    fi
}

# Run main function
main "$@"
