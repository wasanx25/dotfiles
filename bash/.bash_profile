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
if [ -e /Users/wataru0225/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/wataru0225/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"
