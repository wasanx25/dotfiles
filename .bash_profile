
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'

shopt -s autocd
gre() {
   grep -rn $1 --color --exclude-dir=$2;
}

source ~/.git-completion.bash
source ~/.bashrc
