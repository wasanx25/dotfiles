alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias sublime='cd ~/Library/Application\ Support/Sublime\ Text\ 3/'
alias fig='docker-compose'

export ZSH=$HOME/dotfiles/zsh/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(kubectl grails bundle gradle vagrant mix mvn nix brew git docker docker-compose ruby gem rails web-search)
source $ZSH/oh-my-zsh.sh

# Go 環境設定
if [ -x "`which go`" ]; then
    export GOPATH=$HOME/.go
    export PATH=$PATH:$GOPATH/bin
fi
