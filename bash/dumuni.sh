#!/usr/bin/env bash

# get directory from config
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
# what the hell is this abomination
SUBJECT_SCRIPT_DIR="$( dirname -- "$( readlink -f -- "$0")")"
SUBJECTS="$("$SUBJECT_SCRIPT_DIR/"config.sh)"
# for VS Code support
FMAN=($(xdg-mime query default inode/directory | sed 's/.desktop//'))
# replace with whatever editor really
VSCODE_EDITOR_EXEC=vscodium

# possible arguments:
#   > $1 - none | subject code | "open"
#   > $2 - none | "du" | "files" | "f" | "open" | o | "vscode"

[[ "$(alias ll 2>&-)" ]] || alias ll='ls -lav --ignore=..'

SUBJECT="$1"
year_now="$(date +%Y)"
maindir="${SUBJECTS}${SUBJECT}/"

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
            echo "No VS Code workspaces found in $SUBJECT directory!"
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
    elif [[ -z "$2" ]] && ! [[ "$maindir" = "${SUBJECT}/" ]]; then
        cd "${maindir}"
    else
        echo "Error, invalid command!"
    fi
elif [[ "$1" = "open" ]]; then
    r=$($FMAN "$SUBJECTS" -- 2>&- 2<&-) & disown
else
    echo -e "Cannot find directory for specified subject!"
fi
