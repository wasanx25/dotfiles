alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias fig='docker-compose'
alias trr='terraform'

export ZSH=$HOME/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(terraform kubectl grails bundle gradle vagrant mix mvn nix brew git docker docker-compose ruby gem rails web-search)
source $ZSH/oh-my-zsh.sh

# Go 環境設定
if [ -x "`which go`" ]; then
    export GOPATH=$HOME/.go
    export PATH=$PATH:$GOPATH/bin
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

export PATH=${HOME}/.cargo/bin:${PATH}

export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

if which jenv > /dev/null; then
  export JENV_ROOT=/usr/local/var/jenv
  eval "$(jenv init -)"
fi

export EDITOR=vim
eval "$(direnv hook zsh)"

source $HOME/zsh_functions/extend_fzf.sh
