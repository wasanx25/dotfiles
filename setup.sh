#!/bin/sh

### setup vim ###
if [ ! -e $HOME/.vim/bundle ]; then
  mkdir $HOME/.vim/bundle
fi

if [ ! -e $HOME/.vim/bundle/neobundle.vim ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
fi

ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc


### setup shell by default shell###
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


### setup git config ###
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/.gitignore_global ~/.gitignore_global


### setup tmux config ###
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf


### setup nix config if it is nixos ###
case "$(uname -n)" in
  "nixbox")
    sudo ln -s ~/dotfiles/nix/service-configuration.nix /etc/nixos/service-configuration.nix
    sudo nixos-rebuild switch
    ;;
esac
