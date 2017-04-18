abbr -a gst="git status"
abbr -a gb="git branch"
abbr -a gco="git checkout"
abbr -a gd="git diff"
abbr -a gsync="git checkout master; git fetch upstream; git merge upstream/master"
abbr -a gup="git pull --rebase"

function l
  ls -lah
end

function ef
  nvim $HOME/.config/fish/config.fish"
end

function sf
  source $HOME/.config/fish/config.fish
end
