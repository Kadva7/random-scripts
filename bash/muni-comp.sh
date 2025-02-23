#!/usr/bin/env bash

function _muni_get_directory() {
    [ -f '~/.config/muni-script' ] && echo "$(cat "~/.config/muni-script")" && return 0

    # constant
    local DIR="/home/kadva7/Documents/muni/"
    echo "$DIR" > ~/.config/muni-script
    echo "$DIR"
}

function _muni_du_comp() {
    local cmd="${1##*/}"  # get current command
    local word="${COMP_WORDS[COMP_CWORD]}"
    local farg="${COMP_WORDS[1]}"
    local sarg="${COMP_WORDS[2]}"
    local last="${COMP_WORDS[COMP_CWORD - 1]}"
    local exclude="!.*"
    # cd "/home/kadva7/Documents/muni"
    local m_dir="$(_muni_get_directory)"
    local clistmain=("open")
    local clistsub=("open" "du" "list" "files" "vscode")

    if [ -n "$sarg" ]; then
        for cmd in $clistsub; do
            [ "$sarg" = "$cmd" ] && return 0
        done
    fi

    if [ -n "$farg" ]; then
        for cmd in $clistmain; do
            [ "$farg" = "$cmd" ] && return 0
        done
    fi

    if [[ -n "$sarg" ]] && [[ -d "${m_dir}$last" ]]; then
        COMPREPLY=($(cd "${m_dir}$last" && compgen -d -f -W "du o open list" -- "${word}"))
    else
        COMPREPLY=($(cd "$m_dir" && compgen -d -W "open " -- "${word}"))
    fi
}

complete -X '.[^./]*' -F _muni_du_comp muni

