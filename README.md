# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io).

## Bootstrap a new machine

```bash
curl -fsSL https://raw.githubusercontent.com/chadhietala/dotfiles/main/bootstrap.sh | bash
```

This will:
1. Install Homebrew
2. Install chezmoi
3. Clone this repo to `~/Code/dotfiles`
4. Apply all dotfiles and run install scripts

## Structure

```
dotfiles/
  bootstrap.sh        # run once on a new machine
  home/               # chezmoi source root (.chezmoiroot)
    Brewfile          # homebrew packages
    dot_gitconfig
    dot_config/
    .chezmoiscripts/  # install scripts, run during chezmoi apply
```

## Daily use

```bash
chezmoi add ~/.config/foo    # track a new file
chezmoi edit ~/.gitconfig    # edit a managed file
chezmoi apply                # apply changes to home directory
chezmoi diff                 # preview changes before applying
```
