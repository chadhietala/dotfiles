function fish_prompt --description 'Write out the prompt'
  set last_status $status
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l normal (set_color normal)

  set host_color cyan
  set cwd_color yellow

  set cur_host (hostname -s)
  set cur_cwd (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')

  set -g fish_prompt_last_host $cur_host
  set -g fish_prompt_last_cwd $cur_cwd

  echo -e ''

  set_color $host_color;           echo -n $cur_host
  set_color $fish_color_separator; echo -n ': '
  set_color $cwd_color;            echo -n $cur_cwd $normal
  echo -e '' $normal
  echo -e -n -s '→ ' $normal
end
