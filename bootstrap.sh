#! /bin/sh
set -ue

cd $HOME
if [ ! -e $HOME/bin ]; then
  mkdir $HOME/bin
fi

if [ ! $(echo $PATH | grep $HOME/bin) ]; then
  export PATH=$PATH:$HOME/bin
fi

case "$(uname)" in
  "Darwin")
    ghq_file="ghq_darwin_amd64"
    ;;
  "Linux")
    ghq_file="ghq_linux_amd64"
    ;;
  *)
    echo "unknown uname: $(uname)"
    exit 1
    ;;
esac

if [ ! $(which git) ]; then
  git_version="2.19.1"
  git_file="git-${git_version}"
  curl -L -O "https://www.kernel.org/pub/software/scm/git/${git_file}.tar.gz"
  tar -zxf ${git_file}.tar.gz
  cd ${git_file}
  make configure
  ./configure --prefix=/usr
  make
  make install
  cd $HOME
  rm -rf $HOME/${git_file}
fi

git --version

if [ ! $(which ghq) ]; then
  ghq_version="0.8.0"
  curl -L -O "https://github.com/motemen/ghq/releases/download/v0.8.0/${ghq_file}.zip"
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
# bin/mitamae-${version} local lib/recipe.rb
