#!/usr/bin/env bash

###
# A bash script for the config file, so that my stupid scripts don't just
# do stuff that is kinda unknown
###
set -e

SCH_CONF_DIR=$([ -z "$SCH_CONF_DIR" ] && echo "$HOME/.config/school-bash" || echo "$SCH_CONF_DIR")
SCH_CONF_FILE=$([ -z "$SCH_CONF_FILE" ] && echo "muni-script" || echo "$SCH_CONF_FILE" )

SUBJ_LOC="$( [ -n "$SUBJ_LOC" ] && echo "$SUBJ_LOC" || echo $(sed -n '1p' "$SCH_CONF_DIR/$SCH_CONF_FILE") )"

[ -s "$SUBJ_LOC" ] && echo "$SUBJ_LOC" && exit 0

while [ ! -s $SUBJ_LOC ] && read -p "Please type where the directory containing the subjects is (directory of them): " line
do
    if [[ -d $line ]]; then
        echo "Do you wish to set \'$line\' as the base directory? (y/N)"
        read inp
        if [[ $inp = y ]] || [[ $inp = Y ]]; then
            mkdir -p "$SCH_CONF_DIR"
            echo "$line" > "$SCH_CONF_DIR/muni-script"
            break
        fi
    else
        echo "\'$line\' is not a directory!"
    fi
done

