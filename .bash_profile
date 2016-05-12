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
