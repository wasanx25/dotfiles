#!/bin/sh

CURRENT_DIR=`pwd`

### setup vim ###
if [ ! -e $HOME/.vim/bundle ]; then
  mkdir $HOME/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

ln -sf $CURRENT_DIR/vim/.vimrc $HOME/.vimrc


### setup lessfilter config ###
ln -sf $CURRENT_DIR/.lessfilter $HOME/.lessfilter


### setup shell by default shell###
DEFAULT=${SHELL##*/}

case $DEFAULT in
  "fish")
    ln -sf $CURRENT_DIR/fish/config.fish $HOME/.config/fish/config.fish
    source $HOME/.config/fish/config.fish
    echo $DEFAULT
    ;;
  "zsh")
    ln -sf $CURRENT_DIR/zsh/.zshrc $HOME/.zshrc
    # source $HOME/.zshrc
    echo $DEFAULT
    ;;
  "bash")
    ln -sf $CURRENT_DIR/bash/.bash_profile $HOME/.bash_profile
    source $HOME/.bashrc
    echo $DEFAULT
    ;;
  *)
    echo "unknown shell: $DEFAULT"
    exit 1
    ;;
esac


### setup git config ###
ln -sf $CURRENT_DIR/git/.gitconfig $HOME/.gitconfig
ln -sf $CURRENT_DIR/git/.gitignore_global $HOME/.gitignore_global


### setup tmux config ###
ln -sf $CURRENT_DIR/tmux/.tmux.conf $HOME/.tmux.conf


### setup nix config if it is nixos ###
case "$(uname -n)" in
  "nixbox")
    sudo ln -s $CURRENT_DIR/nix/service-configuration.nix /etc/nixos/service-configuration.nix
    sudo nixos-rebuild switch
    ;;
esac
