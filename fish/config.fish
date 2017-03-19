alias lsr='ls -lR'
alias lst='ls -lat'
alias lsa='ls -la'
alias fig='docker-compose'

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt
  set_color purple
  printf '%s ' (date "+%m/%d/%y")
  set last_status $status
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal
  printf '%s ' (__fish_git_prompt)
  set_color normal
  set_color ff0
  printf '\n~> '
end

function fish_user_key_bindings
  bind \cr peco_select_history
  bind \cq peco_find_file
end

function peco_select_history
  if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history|peco $peco_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end

function peco_kill
  ps ax -o pid,time,command | peco --query "$LBUFFER" | awk '{print $1}' | xargs kill
end

# function peco_find_file
#   if test (git rev-parse 2> /dev/null)
#     source_files=$(git ls-files)
#   else
#     source_files=$(find . -type f)
#   end
#   selected_files=$(echo $source_files | peco --prompt "[find file]")
# end


function drma
  docker rm (docker ps -a -q)
end
