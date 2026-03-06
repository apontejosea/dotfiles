#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
ASSUME_YES=0
WITH_RUST=0
SKIP_DEPS=0
REPO_URL=""
REPO_DIR="$HOME/dotfiles"

timestamp="$(date +%Y%m%d%H%M%S)"

log() {
  printf '[INFO] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1" >&2
}

die() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Sets up this dotfiles repo on Linux by installing dependencies,
backing up existing config, and creating symlinks.

Options:
  --repo-url URL       Clone/pull from this repo URL into --repo-dir
  --repo-dir PATH      Repo path for --repo-url mode (default: ~/dotfiles)
  --with-rust          Install rustup (recommended for ~/.cargo/env)
  --skip-deps          Skip package installation
  --yes, -y            Non-interactive mode
  --dry-run            Print actions without making changes
  --help, -h           Show this help

Examples:
  ./bootstrap.sh
  ./bootstrap.sh --yes --with-rust
  ./bootstrap.sh --repo-url https://github.com/you/dotfiles.git --yes
EOF
}

confirm() {
  local prompt="$1"
  if [[ "$ASSUME_YES" -eq 1 ]]; then
    return 0
  fi

  read -r -p "$prompt [y/N]: " reply
  [[ "$reply" == "y" || "$reply" == "Y" ]]
}

run_cmd() {
  local cmd="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[DRY] %s\n' "$cmd"
    return 0
  fi
  printf '[RUN] %s\n' "$cmd"
  eval "$cmd"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_pkg_manager() {
  if have_cmd apt-get; then
    echo "apt"
    return
  fi
  if have_cmd dnf; then
    echo "dnf"
    return
  fi
  if have_cmd pacman; then
    echo "pacman"
    return
  fi
  echo ""
}

install_deps() {
  local pm
  pm="$(detect_pkg_manager)"
  if [[ -z "$pm" ]]; then
    warn "Could not detect apt/dnf/pacman; skipping dependency install"
    return 0
  fi

  log "Detected package manager: $pm"
  if ! confirm "Install required packages with $pm?"; then
    warn "Skipping dependency installation"
    return 0
  fi

  case "$pm" in
    apt)
      if ! run_cmd "sudo apt update"; then
        warn "apt update failed. This is often caused by a broken third-party apt source."
        warn "Fix or disable the failing source, then re-run bootstrap (or use --skip-deps)."
        return 1
      fi
      if [[ "$ASSUME_YES" -eq 1 ]]; then
        if ! run_cmd "sudo apt install -y git bash neovim make gcc unzip ripgrep xclip libnotify-bin python3 curl"; then
          warn "apt install failed. You can re-run with --skip-deps after fixing apt."
          return 1
        fi
      else
        if ! run_cmd "sudo apt install git bash neovim make gcc unzip ripgrep xclip libnotify-bin python3 curl"; then
          warn "apt install failed. You can re-run with --skip-deps after fixing apt."
          return 1
        fi
      fi
      ;;
    dnf)
      if [[ "$ASSUME_YES" -eq 1 ]]; then
        if ! run_cmd "sudo dnf install -y git bash neovim make gcc unzip ripgrep xclip libnotify python3 curl"; then
          warn "dnf install failed. You can re-run with --skip-deps."
          return 1
        fi
      else
        if ! run_cmd "sudo dnf install git bash neovim make gcc unzip ripgrep xclip libnotify python3 curl"; then
          warn "dnf install failed. You can re-run with --skip-deps."
          return 1
        fi
      fi
      ;;
    pacman)
      if [[ "$ASSUME_YES" -eq 1 ]]; then
        if ! run_cmd "sudo pacman -S --noconfirm --needed git bash neovim make gcc unzip ripgrep xclip libnotify python curl"; then
          warn "pacman install failed. You can re-run with --skip-deps."
          return 1
        fi
      else
        if ! run_cmd "sudo pacman -S --needed git bash neovim make gcc unzip ripgrep xclip libnotify python curl"; then
          warn "pacman install failed. You can re-run with --skip-deps."
          return 1
        fi
      fi
      ;;
  esac

  return 0
}

clone_or_update_repo() {
  if [[ -z "$REPO_URL" ]]; then
    DOTFILES_DIR="$SCRIPT_DIR"
    log "Using local repo: $DOTFILES_DIR"
    return
  fi

  DOTFILES_DIR="$REPO_DIR"
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Repo exists, pulling latest changes in $DOTFILES_DIR"
    run_cmd "git -C \"$DOTFILES_DIR\" pull --ff-only"
  elif [[ -e "$DOTFILES_DIR" ]]; then
    die "Target repo dir exists but is not a git repo: $DOTFILES_DIR"
  else
    log "Cloning repo into $DOTFILES_DIR"
    run_cmd "git clone \"$REPO_URL\" \"$DOTFILES_DIR\""
  fi
}

backup_target() {
  local target="$1"
  local backup="${target}.backup.${timestamp}"

  if [[ -L "$target" || -e "$target" ]]; then
    run_cmd "mv \"$target\" \"$backup\""
    log "Backed up $target -> $backup"
  fi
}

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    die "Source path does not exist: $source"
  fi

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      log "Already linked: $target"
      return
    fi
  fi

  if [[ "$target" == *"/"* ]]; then
    run_cmd "mkdir -p \"$(dirname "$target")\""
  fi

  backup_target "$target"
  run_cmd "ln -s \"$source\" \"$target\""
  log "Linked $target -> $source"
}

install_rust() {
  if have_cmd cargo; then
    log "cargo already installed; skipping rustup install"
    return
  fi

  if ! confirm "Install Rust via rustup?"; then
    warn "Skipping Rust installation"
    return
  fi

  run_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
}

verify_setup() {
  local missing=()
  local cmd
  for cmd in git nvim xclip notify-send python3; do
    if ! have_cmd "$cmd"; then
      missing+=("$cmd")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Missing commands: ${missing[*]}"
  else
    log "Command check passed"
  fi

  if [[ ! -f "$HOME/.cargo/env" ]]; then
    warn "~/.cargo/env not found; .bashrc will warn until Rust is installed"
  fi

  log "Bootstrap complete"
  log "Run: source \"$HOME/.bashrc\""
  log "Then start Neovim: nvim"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo-url)
        [[ $# -ge 2 ]] || die "Missing value for --repo-url"
        REPO_URL="$2"
        shift 2
        ;;
      --repo-dir)
        [[ $# -ge 2 ]] || die "Missing value for --repo-dir"
        REPO_DIR="$2"
        shift 2
        ;;
      --with-rust)
        WITH_RUST=1
        shift
        ;;
      --skip-deps)
        SKIP_DEPS=1
        shift
        ;;
      --yes|-y)
        ASSUME_YES=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done
}

main() {
  parse_args "$@"

  clone_or_update_repo

  if [[ "$SKIP_DEPS" -eq 0 ]]; then
    if ! install_deps; then
      warn "Continuing without dependency installation"
    fi
  else
    log "Skipping dependency installation (--skip-deps)"
  fi

  if [[ "$WITH_RUST" -eq 1 ]]; then
    install_rust
  fi

  link_path "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
  link_path "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

  verify_setup
}

main "$@"
