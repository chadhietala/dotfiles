# Aliases
alias sz='source ~/.zshrc'
alias ez='vim ~/.zshrc'
alias l="ls -a"
alias nom="rm -rf node_modules && npm cache clean && npm i"
alias nombom="rm -rf node_modules && npm cache clean && npm i && rm -rf bower_components && bower install"
alias mkdir="mkdir -p"

# DON'T BEEP AT ME!
setopt NO_HIST_BEEP 
setopt NO_LIST_BEEP

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

# Functions

# Show man page in Preview.app.
# $ manp cd
function manp {
  local page
  if (( $# > 0 )); then
    for page in "$@"; do
      man -t "$page" | open -f -a Preview
    done
  else
    print 'What manual page do you want?' >&2
  fi
}

function hack() {
  if ($1 == "up"); then
    git pull --rebase
  else
    print 'Hackity Hack...'
    local dir="~/workspace/$1"
    mkdir $dir
    cd $dir
    touch .gitignore
    echo "node_modules\n.DS_Store\nnpm-debug.log\nnpm-shrinkwrap.json" > .gitignore
    git init
    npm init
  fi
}

# Opens file in EDITOR.
function edit() {
  local dir=$1
  [[ -z "$dir" ]] && dir='.'
  $EDITOR $dir
}
alias e=edit

# Source nvm
source ~/.nvm/nvm.sh