#!/usr/bin/env bash

symlink_dotfiles() {
  set +e
  for file in $@; do
    ln -fs $HOME/.dotfiles/$file $HOME/.$file
  done
  set -e
}

clone() {
  set +e
  git clone https://github.com/$1 $HOME/$2
  set -e
}

sudo perl -pi -e 's/%admin\s+ALL=\(ALL\)\s+ALL/%admin ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

sudo apt-get install -y \
  ack-grep \
  aria2 \
  autoconf \
  automake \
  build-essential \
  cmake \
  curl \
  direnv \
  g++ \
  gcc-4.8 \
  git \
  grc \
  jq \
  libtool \
  libtool-bin \
  mercurial \
  mysql-server \
  ncdu \
  pkg-config \
  postgresql \
  python-dev \
  python-pip \
  python-setuptools \
  python3-dev \
  python3-pip \
  ruby \
  silversearcher-ag \
  tig \
  tmate \
  tmux \
  unzip \

sudo apt-get install -y linuxbrew-wrapper
brew
brew update

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

brew tap Homebrew/bundle

clone luan/atom-config .atom
clone luan/vimfiles    .vim
clone luan/dotfiles    .dotfiles

brew bundle --file=~/.dotfiles/Brewfile.linux
brew bundle cleanup --force --file=~/.dotfiles/Brewfile.linux

sudo pip3 install neovim

cd $HOME/.dotfiles
symlink_dotfiles vimrc.local vimrc.local.before dir_colors \
  editrc gemrc gitconfig inputrc pryrc tmux.conf

mkdir -p $HOME/workspace/go
export GOPATH=$HOME/workspace/go

$HOME/.vim/update

user=$(whoami)
sudo chsh -s /usr/bin/fish $user
OMF_CONFIG=$HOME/.dotfiles/omf CI=true fish <(curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install) || true

go get -v -u github.com/vito/boosh
go get -v -u github.com/tools/godep

curl -L  -o /tmp/spiff.zip https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip
mkdir -p $HOME/bin
unzip -o /tmp/spiff.zip -d $HOME/bin

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby --gems=bundler,bosh_cli
curl -L --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish

exec fish -l
