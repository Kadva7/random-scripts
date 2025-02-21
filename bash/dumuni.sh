#!/usr/bin/bash


# main directory const
munidir="/home/kadva7/Documents/muni/"

# possible arguments:
#   > $1 - none | subject code
#   > $2 - none | "du" | "files" | "f"

ll >/dev/null || alias ll='ls -lav --ignore=..'

subject="$1"
year_now="$(date +%Y)"
maindir="${munidir}${subject}/"

if [ -d "$maindir" ]; then
    cd "$maindir"
    if [ "$2" = "du" ]; then
        if [ -d "${maindir}du" ]; then
            cd "du"
        elif [ -d "${maindir}du${year_now}" ]; then
            cd "du${year_now}"
        else
            echo "Cannot find homework folder!"
        fi
    elif [ "$2" = "f" ] || [ "$2" = "files" ]; then
        ls -ahil "${maindir}"
    fi
else
    echo "Cannot find directory for specified subject!"
fi



