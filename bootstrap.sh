#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/Code/dotfiles"
DOTFILES_REPO="https://github.com/chadhietala/dotfiles.git"

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# chezmoi
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  brew install chezmoi
fi

# Clone dotfiles
mkdir -p "$HOME/Code"
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Write chezmoi config
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$DOTFILES_DIR"
EOF

# Apply
echo "Applying dotfiles..."
chezmoi apply
