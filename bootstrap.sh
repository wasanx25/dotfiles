#! /bin/sh
set -ue
version="1.6.3"

cd $HOME
if [ ! -e $HOME/bin ]; then
  mkdir $HOME/bin
fi

case "$(uname)" in
  "Darwin")
    ghq_file="ghq_darwin_amd64"
    mitamae_file="mitamae-x86_64-darwin"
    ;;
  "Linux")
    ghq_file="ghq_linux_amd64"
    mitamae_file="mitamae-x86_64-linux"
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

if [ ! -e bin/mitamae-${version} ]; then
  curl -L -O "https://github.com/itamae-kitchen/mitamae/releases/download/v${version}/${mitamae_file}"
  chmod +x ${mitamae_file}
  mv ${mitamae_file} ./bin/mitamae-${version}
fi

bin/mitamae-${version} local lib/recipe.rb
