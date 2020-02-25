alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias fig='docker-compose'
alias trr='terraform'
alias ghr='github-release'
alias vi='vim'
alias insdetekt='(){curl -L "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/$1/detekt-cli-$1-all.jar" -o detekt-$1.jar}'

export ZSH=$HOME/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(cargo kubectl bundler vagrant mix brew git docker docker-compose ruby gem rails)
source $ZSH/oh-my-zsh.sh

# Go 環境設定
if [[ -x `which go` ]]; then
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

if [[ -x `which jenv` ]] then
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

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff'
else
  alias diff='diff'
fi

# bindkey -v
# source $HOME/zshfuns/vim_mode.sh

if [[ -x `which nodenv` ]]; then
  export PATH="/Users/wasanx25/.nodenv/shims:${PATH}"
  export NODENV_SHELL=zsh
  source '/usr/local/Cellar/nodenv/1.3.1/libexec/../completions/nodenv.zsh'
  command nodenv rehash 2>/dev/null
  nodenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
    rehash|shell)
      eval "$(nodenv "sh-$command" "$@")";;
    *)
      command nodenv "$command" "$@";;
    esac
  }
fi
