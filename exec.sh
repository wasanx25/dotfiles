#!/bin/sh
mkdir ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

DEFAULT=${SHELL##*/}

case $DEFAULT in
  "fish")
    source ~/.config/fish/config.fish
    echo $DEFAULT
    ;;
  "zsh")
    source ~/.zshrc
    echo $DEFAULT
    ;;
  "bash")
    source ~/.bashrc
    echo $DEFAULT
    ;;
  *)
    echo "unknown shell: $DEFAULT"
    exit 1
    ;;
esac

case "$(uname -n)" in
  "nixbox")
    sudo ln -s ~/dotfiles/nix/service-configuration.nix /etc/nixos/service-configuration.nix
    sudo nixos-rebuild switch
    ;;
esac
