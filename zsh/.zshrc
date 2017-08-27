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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/wataru0225/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/wataru0225/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/wataru0225/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/wataru0225/google-cloud-sdk/completion.zsh.inc'; fi

function fzf-select-history() {
  BUFFER=$(fc -l -r -n 1 | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}

zle -N fzf-select-history
bindkey '^R' fzf-select-history

