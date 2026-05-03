if status is-interactive
    # Commands to run in interactive sessions can go here
end


set WEAVER_URLS https://1.weaver.corp.atd.disco.linkedin.com:14667

function gco
    git checkout $argv
end

complete -c gco -f -a '(__fish_git_branches)' --description 'Branch'
complete -c gco -f -a '(__fish_git_tags)' --description 'Tag'
complete -c gco -s b -d 'Create a new branch'
complete -c gco -s B -d 'Create a new branch or reset to an existing one'
complete -c gco -s t -l track -d 'Track a remote branch'

function git_current_branch
  git branch | grep '*' | cut -c3-
end

# git push to current branch
function ggpush
    git push origin (git_current_branch) $argv
end

complete -c ggpush -s f -l force -d 'Force push'
complete -c ggpush -s u -l set-upstream -d 'Set upstream for the branch'
complete -c ggpush -s d -l delete -d 'Delete a branch'

# git pull with rebase
function gup
    git pull --rebase
end

function grb
  git rebase $argv
end

complete -c grb -f -a '(__fish_git_branches)' --description 'Branch'
complete -c grb -s i -l interactive -d 'Interactive rebase'

# git commit with message
function gcm
    git commit -m $argv
end

complete -c gcm -f -a '(__fish_git_modified_files)' --description 'Modified file'

function gst
    git status
end
complete -c gst -s s -l short -d 'Show short status'

function git_newpr
    set -l pr_commit $argv[1]
    if test -z "$pr_commit"
        set pr_commit integration
    end

    # Generate branch name from commit subject
    set -l branch_name (git show --no-patch --format="%f" "$pr_commit")

    # Create branch from origin/main (the protected branch)
    git branch --no-track "$branch_name" origin/main
    git switch "$branch_name"

    # Cherry pick from your integration branch
    if not git cherry-pick "$pr_commit"
        git cherry-pick --abort
        git switch integration
        exit 1
    end

    git -c push.default=current push
    gh pr create --base main  # PR targets protected main
    git switch integration
end

function git_updatepr
    if test (count $argv) -ne 1
        echo "usage: $argv[0] <pr-commit>" >&2
        exit 1
    end

    set -l pr_commit $argv[1]
    set -l branch_name (git show --no-patch --format="%f" "$pr_commit")

    git switch "$branch_name"

    # Cherry-pick from integration instead of main
    if not git cherry-pick integration
        git cherry-pick --abort
        git switch integration
        exit 1
    end

    git push
    git switch integration

    # Squash the update into the PR commit on integration branch
    set -x GIT_SEQUENCE_EDITOR /usr/bin/true
    git commit --amend --fixup="$pr_commit"
    git rebase --interactive --autosquash "$pr_commit"^
end

git config --global alias.newpr '!git_newpr'
git config --global alias.updatepr '!git_updatepr'

complete -c git-newpr -f -a '(__fish_git_branches)' --description 'Branch'


starship init fish | source

set -U fish_greeting ""

direnv hook fish | source
set -g direnv_fish_mode disable_arrow

eval "$(/opt/homebrew/bin/brew shellenv)"

function jup
  jj git fetch && jj rebase --skip-emptied -r 'mutable() & mine()' -d master
end

# Added by Antigravity
fish_add_path /Users/chietala/.antigravity/antigravity/bin

# opencode
fish_add_path /Users/chietala/.opencode/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
