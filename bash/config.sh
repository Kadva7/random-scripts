#!/usr/bin/env bash

###
# A bash script for the config file, so that my stupid scripts don't just
# do stuff that is kinda unknown
###

SUBJECTS="$( [ -n "$SUBJECTS" ] && echo "$SUBJECTS" || echo ~/.config/school-bash/muni-script)"

[[ -s $SUBJECTS ]] && echo "$(cat -- "$SUBJECTS")" && exit 0

while [ ! -s $SUBJECTS ] && read -p "Please type where the directory containing the subjects is (directory of them): " line
do
    if [[ -d "$line" ]]; then
        echo "Do you wish to set \'$line\' as the base directory? (y/N)"
        read inp
        if [[ "$inp" = "y" ]] || [[ "$inp" = "Y" ]]; then
            echo "$line" > "$SUBJECTS"
            break
        fi
    else
        echo "\'$line\' is not a directory!"
    fi

done

