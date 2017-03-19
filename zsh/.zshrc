alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias sublime='cd ~/Library/Application\ Support/Sublime\ Text\ 3/'
alias fig='docker-compose'

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(bundle gradle vagrant mix mvn nix brew git docker docker-compose ruby gem rails web-search)
source $ZSH/oh-my-zsh.sh
