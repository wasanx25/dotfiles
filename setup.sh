#!/bin/sh
mkdir ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/.profile ~/.profile
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc

DEFAULT=${SHELL##*/}

case $DEFAULT in
  "fish")
    ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
    source ~/.config/fish/config.fish
    echo $DEFAULT
    ;;
  "zsh")
    ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
    source ~/.zshrc
    echo $DEFAULT
    ;;
  "bash")
    ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile
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
