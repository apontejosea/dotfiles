#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

failures=0
warnings=0

usage() {
  cat <<'EOF'
Usage: ./check.sh [options]

Validates dotfiles setup without making changes.

Options:
  --repo-dir PATH   Dotfiles repo path to validate against (default: script directory)
  --help, -h        Show this help
EOF
}

info() {
  printf '[INFO] %s\n' "$1"
}

ok() {
  printf '[ OK ] %s\n' "$1"
}

warn() {
  warnings=$((warnings + 1))
  printf '[WARN] %s\n' "$1"
}

fail() {
  failures=$((failures + 1))
  printf '[FAIL] %s\n' "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_cmd() {
  local cmd="$1"
  if have_cmd "$cmd"; then
    ok "Command available: $cmd"
  else
    fail "Missing command: $cmd"
  fi
}

check_symlink() {
  local target="$1"
  local expected="$2"

  if [[ ! -L "$target" ]]; then
    if [[ -e "$target" ]]; then
      fail "$target exists but is not a symlink"
    else
      fail "$target does not exist"
    fi
    return
  fi

  local current
  current="$(readlink "$target")"
  if [[ "$current" == "$expected" ]]; then
    ok "Symlink correct: $target -> $expected"
  else
    fail "Symlink mismatch: $target -> $current (expected $expected)"
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo-dir)
        [[ $# -ge 2 ]] || {
          printf '[ERROR] Missing value for --repo-dir\n' >&2
          exit 2
        }
        REPO_DIR="$2"
        shift 2
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        printf '[ERROR] Unknown option: %s\n' "$1" >&2
        exit 2
        ;;
    esac
  done
}

main() {
  parse_args "$@"

  REPO_DIR="$(cd "$REPO_DIR" && pwd)"

  info "Validating dotfiles setup"
  info "Repo dir: $REPO_DIR"

  if [[ ! -f "$REPO_DIR/.bashrc" ]]; then
    fail "Repo file missing: $REPO_DIR/.bashrc"
  else
    ok "Repo file present: $REPO_DIR/.bashrc"
  fi

  if [[ ! -d "$REPO_DIR/.config/nvim" ]]; then
    fail "Repo dir missing: $REPO_DIR/.config/nvim"
  else
    ok "Repo dir present: $REPO_DIR/.config/nvim"
  fi

  check_symlink "$HOME/.bashrc" "$REPO_DIR/.bashrc"
  check_symlink "$HOME/.config/nvim" "$REPO_DIR/.config/nvim"

  check_cmd git
  check_cmd nvim
  check_cmd xclip
  check_cmd notify-send
  check_cmd python3

  if [[ -f "$HOME/.cargo/env" ]]; then
    ok "Rust environment file present: $HOME/.cargo/env"
  else
    warn "Rust environment file missing: $HOME/.cargo/env"
  fi

  printf '\n'
  info "Checks finished: failures=$failures warnings=$warnings"

  if [[ "$failures" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
