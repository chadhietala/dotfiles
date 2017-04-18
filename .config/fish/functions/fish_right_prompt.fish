function fish_right_prompt -d "Write out the right prompt"
  set -l last_status $status
  set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD ^/dev/null)
  test -n "$repo_info"
  or return


  set -l green (set_color green)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l normal (set_color normal)
  set branch_glyph \uE0A0
  set detached_glyph \u27A6

  function _git_is_dirty
    echo (command git status -s --ignore-submodules=dirty ^/dev/null)
  end

  function _git_branch_name
    echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
  end

  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)
    if [ (_git_is_dirty) ]
      set git_info $red $branch_glyph ' [' $git_branch  ']' $normal
    else
      set git_info $green $branch_glyph ' [' $git_branch ']' $normal
    end
    echo -n -s $git_info $normal
  end

  set b (command git symbolic-ref HEAD ^/dev/null; set detached $status)

  if test $detached -ne 0
    set sha (git rev-parse HEAD ^/dev/null)
    echo -n -s $blue $detached_glyph '  ' (string match -r '^.{8}' -- $sha)
  end

  set_color normal
end
