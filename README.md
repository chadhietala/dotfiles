# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io).

## Setting up a new machine

### 1. Run the bootstrap script

```bash
curl -fsSL https://raw.githubusercontent.com/chadhietala/dotfiles/main/bootstrap.sh | bash
```

This installs Homebrew, installs chezmoi, clones this repo to `~/Code/dotfiles`, and runs `chezmoi apply`.

### 2. Answer the setup prompts

`chezmoi init` will prompt for three values that are stored locally and never committed to the repo:

| Prompt | Example |
|---|---|
| Is this a work machine? | `true` or `false` |
| Git author name | Your name |
| Git author email | Your email |

### 3. What gets installed

- **Homebrew packages** — everything in `home/Brewfile` (apps, fonts, CLI tools)
- **Fish plugins** — via fisher, from `home/dot_config/private_fish/fish_plugins`
- **Dotfiles** — gitconfig, fish config, sketchybar, aerospace, btop, starship, borders

---

## Repo structure

```
dotfiles/
  bootstrap.sh                  # run once on a new machine
  home/                         # chezmoi source root (.chezmoiroot)
    .chezmoi.toml.tmpl          # generates local config, prompts for identity
    Brewfile                    # homebrew packages and casks
    dot_gitconfig.tmpl          # git config (name/email injected from local config)
    dot_config/                 # ~/.config files
    .chezmoiscripts/            # scripts run during chezmoi apply
      run_onchange_after_1-install-homebrew.sh.tmpl
      run_onchange_after_2-install-fish-plugins.sh.tmpl
```

---

## Daily use

```bash
chezmoi add ~/.config/foo    # start tracking a new file
chezmoi edit ~/.gitconfig    # edit a managed file in $EDITOR
chezmoi diff                 # preview what apply would change
chezmoi apply                # apply source changes to home directory
chezmoi update               # pull latest from git and apply
```
