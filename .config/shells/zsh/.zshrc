alias lsr='ls -lR'
alias lsa='ls -la'
alias g='git'
alias d='docker'
alias drma='docker rm $(docker ps -a -q)'
alias doco='docker-compose'
alias trr='terraform'
alias ghr='github-release'
alias vi='vim'
alias insdetekt='(){curl -L "https://jcenter.bintray.com/io/gitlab/arturbosch/detekt/detekt-cli/$1/detekt-cli-$1-all.jar" -o detekt-$1.jar}'
alias hidden_clock='defaults write com.apple.menuextra.clock IsAnalog -bool true'
alias show_clock='defaults write com.apple.menuextra.clock IsAnalog -bool false'
alias awk='gawk'
alias x='gh pr create --web'

export ZSH=$HOME/oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(yarn kubectl bundler vagrant mix brew git docker docker-compose ruby gem rails)
source $ZSH/oh-my-zsh.sh
source $HOME/zshfuns/extend_fzf.sh
# bindkey -v
# source $HOME/zshfuns/vim_mode.sh

export LESSCHARSET=utf-8

autoload colors
colors
RPROMPT="%B%{${fg[red]}%}[%~]%{${reset_color}%}%b"
PROMPT='${ret_status} %{$fg[white]%}$(date +%m/%d-%H:%M:%S) %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

setopt hist_ignore_all_dups

export LESS='-R'
if [ -f "$HOME/.lessfilter" ]; then
  export LESSOPEN='|~/.lessfilter %s'
else
  unset LESSOPEN
fi

export EDITOR=vim
# eval "$(direnv hook zsh)"

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff'
else
  alias diff='diff'
fi

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

########################################
## start environment and PATH setting ##
########################################
export PATH=${HOME}/.cargo/bin:${PATH}

if [[ -x `which jenv` ]] then
  export JENV_ROOT=/usr/local/var/jenv
  eval "$(jenv init -)"
fi

if [[ -x `which go` ]]; then
  export GOPATH=$HOME
  export PATH=$PATH:$GOPATH/bin
fi

case "$(uname)" in
  "Darwin")
    export PATH=${PATH}:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:/usr/local/sbin
    ;;
esac

eval "$(starship init zsh)"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"
######################################
## end environment and PATH setting ##
######################################

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/wasanx25/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/wasanx25/works/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/wasanx25/works/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/wasanx25/works/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/wasanx25/works/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(rbenv init - zsh)"

if [ -f '/opt/homebrew/bin/brew' ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
