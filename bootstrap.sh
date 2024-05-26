#! /bin/sh
set -ue

source .versions.sh

cd $HOME
if [ ! -e $HOME/bin ]; then
  mkdir $HOME/bin
fi

if [ ! "$(echo $PATH | grep $HOME/bin)" ]; then
  export PATH=$PATH:$HOME/bin
fi

if [ ! $(which brew) ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
fi

# To force overwrite for using latest
brew install git
brew install ghq

ghq get https://github.com/wasanx25/dotfiles.git
cd $(ghq root)/github.com/wasanx25/dotfiles
git config --global --unset ghq.root # reset before execute provision of git cookbook, already set this in ~/.config/git/config

sh install_mitamae.sh

# execute mitamae
# bin/mitamae-${MITAMAE_VERSION} local lib/recipe.rb
