#!/bin/sh

### setup vim ###
if [ ! -e $HOME/.vim/bundle ]; then
  mkdir $HOME/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

ln -sf $HOME/dotfiles/vim/.vimrc $HOME/.vimrc


### setup shell by default shell###
DEFAULT=${SHELL##*/}

case $DEFAULT in
  "fish")
    ln -sf $HOME/dotfiles/fish/config.fish $HOME/.config/fish/config.fish
    source $HOME/.config/fish/config.fish
    echo $DEFAULT
    ;;
  "zsh")
    ln -sf $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
    source $HOME/.zshrc
    echo $DEFAULT
    ;;
  "bash")
    ln -sf $HOME/dotfiles/bash/.bash_profile $HOME/.bash_profile
    source $HOME/.bashrc
    echo $DEFAULT
    ;;
  *)
    echo "unknown shell: $DEFAULT"
    exit 1
    ;;
esac


### setup git config ###
ln -sf $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/git/.gitignore_global $HOME/.gitignore_global


### setup tmux config ###
ln -sf $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf


### setup nix config if it is nixos ###
case "$(uname -n)" in
  "nixbox")
    sudo ln -s $HOME/dotfiles/nix/service-configuration.nix /etc/nixos/service-configuration.nix
    sudo nixos-rebuild switch
    ;;
esac
