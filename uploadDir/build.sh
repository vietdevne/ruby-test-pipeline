#!/bin/bash

echo "Hello anh em hehehehe"
source ~/.bashrc

export RBENV_ROOT="/home/ubuntu/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
eval "$(rbenv init - bash)"
rbenv global 4.0.3

bundle install
rails db:migrate
