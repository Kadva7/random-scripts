#!/usr/bin/bash


# hw constants
munidir="/home/kadva7/Documents/muni/"

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
    fi
else
    echo "Cannot find directory for specified subject!"
fi



