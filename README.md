# Dotfiles

This repo currently contains a small Linux-focused dotfiles setup:

- `.bashrc` for shell aliases and interactive Bash behavior
- `.config/nvim` for the active Neovim setup
- `z_legacy/vanilla-vim` for the older Vim configuration kept as reference

The Neovim config is the current setup. The legacy Vim files are not needed for a new Linux install.

## Install on a new Linux system

These steps assume you want the files in this repo to be the source of truth by symlinking them into your home directory.

### Automated setup (recommended)

From the repo root:

```sh
./bootstrap.sh --yes --with-rust
```

Useful options:

- `--dry-run` preview actions without changing anything
- `--skip-deps` skip package installation
- `--repo-url <url>` and `--repo-dir <path>` clone/pull before linking

Validate your setup anytime (no changes made):

```sh
./check.sh
```

If dependency installation fails (for example, due to a broken third-party apt repository), bootstrap will continue with symlink setup. You can also skip package installation explicitly:

```sh
./bootstrap.sh --yes --skip-deps
```

### 1. Install dependencies

On Debian/Ubuntu:

```sh
sudo apt update
sudo apt install -y git bash neovim make gcc unzip ripgrep xclip libnotify-bin python3 curl
```

Optional but recommended:

- Install a Nerd Font for Neovim icons
- Install Rust with `rustup`, because `.bashrc` loads `~/.cargo/env`

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

If you use a non-Debian distro, install the equivalent packages with your package manager.

### 2. Clone the repo

```sh
git clone <your-dotfiles-repo-url> "$HOME/dotfiles"
```

### 3. Back up any existing config

```sh
mv "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
mkdir -p "$HOME/.config"
```

### 4. Symlink the tracked files into place

```sh
ln -s "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
ln -s "$HOME/dotfiles/.config/nvim" "$HOME/.config/nvim"
```

### 5. Load the shell config and start Neovim

```sh
source "$HOME/.bashrc"
nvim
```

On first launch, Neovim will install plugins automatically through `lazy.nvim`.

## Keeping the repo in sync with the system

Use symlinks instead of copying files. That way, when you edit `~/.bashrc` or `~/.config/nvim`, you are editing the files inside this repo directly, so `git status` immediately shows the changes.

## Notes

- The `.bashrc` aliases expect `nvim`, `xclip`, `notify-send`, and `python3` to exist
- The active editor setup lives in `.config/nvim`
- `z_legacy/vanilla-vim` is optional and mainly preserved for historical reference
