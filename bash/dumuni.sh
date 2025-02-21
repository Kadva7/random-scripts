#!/usr/bin/bash


# main directory const
munidir="/home/kadva7/Documents/muni/"
FMAN=($(xdg-mime query default inode/directory | sed 's/.desktop//'))

# possible arguments:
#   > $1 - none | subject code | "open"
#   > $2 - none | "du" | "files" | "f" | "open" | o

ll >/dev/null || alias ll='ls -lav --ignore=..'

subject="$1"
year_now="$(date +%Y)"
maindir="${munidir}${subject}/"

if [ -d "$maindir" ]; then
    if [ "$2" = "du" ]; then
        if [ -d "${maindir}du" ]; then
            cd "${maindir}du"
        elif [ -d "${maindir}du${year_now}" ]; then
            cd "${maindir}du${year_now}"
        else
            echo "Cannot find homework folder!"
        fi
    elif [ "$2" = "f" ] || [ "$2" = "files" ]; then
        ls -ahil "$maindir"
    elif [ "$2" = "o" ] || [ "$2" = "open" ]; then
        retGarbage=($($FMAN "$maindir" -- 2>&- 2<&-)) & disown
    else
        cd "${maindir}"
    fi
elif [ "$1" = "open" ]; then
    retGarbage=($($FMAN "$munidir" -- 2>&- 2<&-)) & disown
else
    echo "Cannot find directory for specified subject!"
fi



