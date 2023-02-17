#!/usr/bin/env bash

function source-if-exists() {
  if [[ -f $1 ]]; then
    source "$1"
  else
    echo "Warning: $1 not found"
  fi
}

function command_exists {
    command -v "${@}" > /dev/null 2>&1
}

if [ -f ~/git/aliases-as-a-language/aliases-as-a-language.sh ]; then
  source "$HOME"/git/aliases-as-a-language/aliases-as-a-language.sh
  alias rca='vi $HOME/git/aliases-as-a-language/aliases-as-a-language.sh'
else
  echo "Warning: aliases-as-a-language not found"
fi

##############################
#   DOTFILE MANAGEMENT
##############################
_SHELL=$(basename $SHELL)
RC_FILE=~/.${_SHELL}rc
alias src='source $RC_FILE'
alias rc='vi $RC_FILE && src'


if command_exists "apt"; then
  alias agi='sudo apt install '
else
  echo "Warning: apt not found"
fi

if command_exists "fzf"; then
  alias fzf='fzf --no-mouse '
else
  echo "Warning: fzf not found"
fi


# rq - parse yml and cvs, etc.
# https://github.com/dflemstr/rq/blob/master/doc/installation.md#generic
[ -f "$HOME/.cargo/bin/rq" ] && export PATH="$HOME/.cargo/bin":$PATH
