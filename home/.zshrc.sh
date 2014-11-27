#!/usr/bin/env zsh

# Aliases
alias sz='source ~/.zshrc'
alias ez='vim ~/.zshrc'
alias l="ls -a"
alias nom="rm -rf node_modules && npm cache clean && npm i"
alias nombom="rm -rf node_modules && npm cache clean && npm i && rm -rf bower_components && bower install"
alias mkdir="mkdir -p"

# case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="chietala"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git node)
source $ZSH/oh-my-zsh.sh

# Editors
export EDITOR='/usr/local/bin/subl'
export VISUAL='/usr/local/bin/subl'
export PAGER='less'
