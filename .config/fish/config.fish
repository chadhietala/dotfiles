# Plugins
# no-op the greeting message
function fish_greeting
end

function git_current_branch
  git branch | grep '*' | cut -c3-
end

function ggpush
  git push origin (git_current_branch) $argv
end

function grb
  git rebase $argv
end

function es
  ember serve $argv
end

# Stef magic
function whatchanged
  set repo $argv[1]
  set range $argv[2]

  open https://github.com/$repo/compare/master@\{$range\}...master
end

function morning
  whatchanged emberjs/ember.js 1day
  whatchanged ember-cli/ember-cli 1day
end

# Paths
set -U fish_user_paths /Users/chietala/.cargo/bin $fish_user_paths
