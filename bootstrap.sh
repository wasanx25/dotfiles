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

case "$(uname)" in
  "Darwin")
    case "$(uname -m)" in
      "arm64")
        ghq_file="ghq_darwin_arm64"
        ;;
      "x86_64")
        ghq_file="ghq_darwin_amd64"
        ;;
    esac
    ;;
  "Linux")
    ghq_file="ghq_linux_amd64"
    ;;
  *)
    echo "unknown uname: $(uname)"
    exit 1
    ;;
esac

if [ ! $(which brew) ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# To force overwrite for using latest
brew install git

if [ ! $(which ghq) ]; then
  curl -L -O "https://github.com/motemen/ghq/releases/download/v${GHQ_VERSION}/${ghq_file}.zip"
  unzip -d ${ghq_file} -o ${ghq_file}.zip
  mv ${ghq_file}/ghq $HOME/bin
  rm -rf ${ghq_file}
  git config --global ghq.root ~/src
fi

ghq get https://github.com/wasanx25/dotfiles.git
cd $(ghq root)/github.com/wasanx25/dotfiles
git config --global --unset ghq.root # reset before execute provision of git cookbook, already set this in ~/.config/git/config

sh install_mitamae.sh

# execute mitamae
# bin/mitamae-${MITAMAE_VERSION} local lib/recipe.rb
