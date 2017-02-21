alias lsr='ls -lR'
alias lst='ls -lat'
alias lsa='ls -la'
alias g='git'

function fish_prompt
  set_color purple
  date "+%m/%d/%y"
  set_color FF0
  echo (pwd) "> "
end
