alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias fig='docker-compose'
alias trr='terraform'
alias ghr='github-release'
alias vi='vim'

export ZSH=$HOME/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(terraform kubectl grails bundle gradle vagrant mix mvn nix brew git docker docker-compose ruby gem rails web-search)
source $ZSH/oh-my-zsh.sh

# Go 環境設定
if [ -x "`which go`" ]; then
    export GOPATH=$HOME
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

source $HOME/zshfuns/extend_fzf.sh

autoload colors
colors
RPROMPT="%B%{${fg[red]}%}[%~]%{${reset_color}%}%b"

case "$(uname)" in
  "Darwin")
    export PATH=${PATH}:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:/usr/local/sbin
    ;;
esac
# added by travis gem
[ -f /Users/kikuchi/.travis/travis.sh ] && source /Users/kikuchi/.travis/travis.sh

PROMPT='${ret_status} %{$fg[white]%}$(date +%m/%d-%H:%M:%S) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
