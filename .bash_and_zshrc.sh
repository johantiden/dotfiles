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

if command_exists "fzf"; then
  alias fzf='fzf --no-mouse '
else
  echo "Warning: fzf not found"
fi

# rq - parse yml and cvs, etc.
# https://github.com/dflemstr/rq/blob/master/doc/installation.md#generic
[ -f "$HOME/.cargo/bin/rq" ] && export PATH="$HOME/.cargo/bin":$PATH


##############################
#   GENERAL ALIASES
##############################

alias ll='ls -lah'
alias l='ll'

alias df='df -h'

alias curl='__curl_cleaner'
function __curl_cleaner {
  \curl --silent "${@}" | grep -v "doctype html"
}


##############################
#   APT
##############################
if command_exists "apt"; then
  alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove'
  alias agi='sudo apt install '
fi

##############################
#   PREFERRED TEXT EDITOR
##############################
if command_exists "nvim"; then
  alias z="nvim "
  # Editor for 'pass', etc.
  export EDITOR="nvim"
  alias vi='nvim'
elif command_exists "vi"; then
  alias z="vi "
  # Editor for 'pass', etc.
  export EDITOR="vi"
elif command_exists "nano"; then
  alias z="nano "
  # Editor for 'pass', etc.
  export EDITOR="nano"
else
  echo "Warning: could not find nvim, vi or nano. WHERE ARE YOU!?"
fi

##############################
#   GIT ALIASES
##############################
if command_exists "git"; then
  alias a='git add '
  alias aa='git add --all'

  alias good='git bisect good'
  alias bad='git bisect bad'
  alias skip='git bisect skip'

  alias merge='git merge'

  #https://www.reddit.com/r/git/comments/avv34g/nicer_gitstatus/
  function __git_status {
    #e.b
    awk -vOFS='' '
        NR==FNR {
            all[i++] = $0;
            difffiles[$1] = $0;
            next;
        }
        ! ($2 in difffiles) {
            print; next;
        }
        {
            gsub($2, difffiles[$2]);
            print;
        }
        END {
            if (NR != FNR) {
                # Had diff output
                exit;
            }
            # Had no diff output, just print lines from git status -s
            for (i in all) {
                print all[i];
            }
        }
    ' \
        <(git diff --color --stat=$(($(tput cols) - 3)) HEAD | sed '$d; s/^ //')\
        <(git -c color.status=always status -s)
  }

  ## Git diff and status
  alias d='git --no-pager diff'
  alias i='_i'
  function _i {
    local D=$(d)
    if [[ -n "${D}" ]]; then
      d
      echo "=================================================="
    fi
    __git_status
  }
else
  echo "Warning: git not found"
fi



##############################
#   MAVEN
##############################
if command_exists "mvn"; then
  alias mci='mvn clean install'
  alias pom='z pom.xml'
else
  echo "Warning: mvn not found"
fi



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
  echo "Warning: docker not found"
fi

##############################
#   IMAGEMAGICK
##############################
if command_exists "convert"; then
  alias gif='convert -delay 50 -loop 0 -alpha remove -dispose Background -background white "${@}"'
else
  echo "Warning: 'convert' imagemagick not found"
fi



##############################
#   SERVERS
##############################
if command_exists "python2"; then
  alias srvhttp='sudo python2 -m SimpleHTTPServer 80'
else
  echo "Warning: python2 not found"
fi

if command_exists "python3"; then
  alias srvftp='sudo python3 -m pyftpdlib -p 21'
  alias srvupload='sudo python3 ~/sync/bin/droopy -m "Send me a file!" 80'
  alias srvimages='sudo python3 ~/sync/bin/simplegallery.py -p 80'
else
  echo "Warning: python3 not found"
fi


##############################
#   SUBLIME TEXT
##############################
if command_exists "subl"; then
  alias subl='subl -n '
  alias sublw='subl -nw '
else
  echo "Warning: subl not found"
fi
