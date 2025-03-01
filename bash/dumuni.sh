#!/usr/bin/bash

# main directory const
function _muni_get_directory() {
    [ -f '~/.config/muni-script' ] && echo "$(cat "~/.config/muni-script")" && return 0

    # constant
    local DIR="/home/kadva7/Documents/muni/"
    echo "$DIR" > ~/.config/muni-script
    echo "$DIR"
}

munidir="$(_muni_get_directory)"
FMAN=($(xdg-mime query default inode/directory | sed 's/.desktop//'))
VSCODE_EDITOR_EXEC=vscodium

# possible arguments:
#   > $1 - none | subject code | "open"
#   > $2 - none | "du" | "files" | "f" | "open" | o | "vscode"

[ "$(alias ll 2>&-)" ] || alias ll='ls -lav --ignore=..'

subject="$1"
year_now="$(date +%Y)"
maindir="${munidir}${subject}/"

if [[ -d "$maindir" ]]; then
    if [[ "$2" = du ]]; then
        if [[ -d "${maindir}du" ]]; then
            cd "${maindir}du"
        elif [[ -d "${maindir}du${year_now}" ]]; then
            cd "${maindir}du${year_now}"
        else
            echo "Cannot find homework folder!"
        fi
    elif [[ "$2" = f ]] || [[ "$2" = files ]]; then
        ls -ahil "$maindir"
    elif [[ "$2" = o ]] || [[ "$2" = open ]]; then
        r=$($FMAN "$maindir" -- 2>&- 2<&-) & disown
    elif [[ "$2" = l ]] || [[ "$2" = list ]]; then
        ll "$maindir"
    elif [[ "$2" = vscode ]]; then
        # EDITOR
        editor=vscodium
        [[ "$(vscodium --help 2>&-)" ]] || (echo "No VS Codium detected! Please set editor to what you use instead of it!" && return 1)

        workspaces=($(cd "${maindir}" && find -P -xdev -name "*.code-workspace"))
        if [[ ${#workspaces[@]} -eq 0 ]]; then
            echo "No VS Code workspaces found in subject directory!"
        elif [[ ${#workspaces[@]} -eq 1 ]]; then
            vscodium "${maindir}${workspaces[0]}"
        else
            echo "Multiple workspaces found!"
            i=0
            for elem in ${workspaces[*]}; do
                echo "[$i] $elem"
                i=$((i + 1))
            done
            while read -p "Enter a number between 0 and $((i - 1)): " num; do
                if ! [[ $num == +([0-9]) ]]; then
                    echo "Input must be a non-negative integer!"
                elif [[ $num -lt 0 ]] || [[ $num -gt $((i - 1)) ]]; then
                    echo "Number must be between the possible value!"
                else
                    vscodium "${maindir}${workspaces[num]}"
                    break
                fi
            done
        fi
    elif [[ -z "$2" ]] then
        cd "${maindir}"
    else
        echo "Error, invalid command!"
    fi
elif [ "$1" = "open" ]; then
    r=$($FMAN "$munidir" -- 2>&- 2<&-) & disown
else
    echo -e "Cannot find directory for specified subject!"
fi
