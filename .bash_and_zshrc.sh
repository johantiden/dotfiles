#!/usr/bin/env bash

function source-if-exists() {
  if [[ -f $1 ]]; then
    source "$1"
  else
    echo "$0 Warning: $1 not found"
  fi
}

function command_exists {
    command -v "${@}" > /dev/null 2>&1
}

if [ -f ~/git/aliases-as-a-language/aliases-as-a-language.sh ]; then
  source "$HOME"/git/aliases-as-a-language/aliases-as-a-language.sh
  alias rca='vi $HOME/git/aliases-as-a-language/aliases-as-a-language.sh'
else
  echo "$0 Warning: aliases-as-a-language not found"
fi

##############################
#   DOTFILE MANAGEMENT
##############################
_SHELL=$(basename $SHELL)
RC_FILE=~/.${_SHELL}rc
alias src='source $RC_FILE'
alias rc='vi $RC_FILE && src'

##############################
#   DOCKER
##############################
if command_exists "docker"; then
  function docker-bash {
    local container="$(docker ps | grep "${1}" | cut -d' ' -f1)"
    docker exec -it "${container}" bash
  }

  function get_single_docker_container {
    docker ps | tail -n1 | cut -d' ' -f1
  }

  function sudo_get_single_docker_container {
    sudo docker ps | tail -n1 | cut -d' ' -f1
  }

  alias log=sudo_docker_logs_single_container
  function sudo_docker_logs_single_container {
    sudo docker logs -f -n 1000 $(sudo_get_single_docker_container)
  }
else
  echo "$0 Warning: docker not found"
fi

##############################
#   IMAGEMAGICK
##############################
if command_exists "convert"; then
  alias gif='convert -delay 50 -loop 0 -alpha remove -dispose Background -background white "${@}"'
else
  echo "$0 Warning: 'convert' imagemagick not found"
fi


