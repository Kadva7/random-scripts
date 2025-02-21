#!/usr/bin/env bash

DIRECTORY="/home/kadva7/Documents/muni/"

function _muni_du_comp() {
    local cmd="${1##*/}"  # get current command
    local word="${COMP_WORDS[COMP_CWORD]}"
    local exclude="!.*"

    #if ! [ -d "$2" ]; then
    #else
    #    COMPREPLY=($(cd "${DIRECTORY}$2/" && compgen -d -f -X "${exclude}" -- "${word}"))
    #    echo -e "EXECUTED"
    #fi
    COMPREPLY=($(cd "$DIRECTORY" && compgen -d -- "${word}"))
}

complete -d -X '.[^./]*' -F _muni_du_comp muni

