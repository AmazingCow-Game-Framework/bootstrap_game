#!/bin/bash
##----------------------------------------------------------------------------##
##               █      █                                                     ##
##               ████████                                                     ##
##             ██        ██                                                   ##
##            ███  █  █  ███        setup_projs.sh                            ##
##            █ █        █ █        bootstrap_game                            ##
##             ████████████                                                   ##
##           █              █       Copyright (c) 2017                        ##
##          █     █    █     █      AmazingCow - www.AmazingCow.com           ##
##          █     █    █     █                                                ##
##           █              █       N2OMatt - n2omatt@amazingcow.com          ##
##             ████████████         www.amazingcow.com/n2omatt                ##
##                                                                            ##
##                  This software is licensed as GPLv3                        ##
##                 CHECK THE COPYING FILE TO MORE DETAILS                     ##
##                                                                            ##
##    Permission is granted to anyone to use this software for any purpose,   ##
##   including commercial applications, and to alter it and redistribute it   ##
##               freely, subject to the following restrictions:               ##
##                                                                            ##
##     0. You **CANNOT** change the type of the license.                      ##
##     1. The origin of this software must not be misrepresented;             ##
##        you must not claim that you wrote the original software.            ##
##     2. If you use this software in a product, an acknowledgment in the     ##
##        product IS HIGHLY APPRECIATED, both in source and binary forms.     ##
##        (See opensource.AmazingCow.com/acknowledgment.html for details).    ##
##        If you will not acknowledge, just send us a email. We'll be         ##
##        *VERY* happy to see our work being used by other people. :)         ##
##        The email is: acknowledgment_opensource@AmazingCow.com              ##
##     3. Altered source versions must be plainly marked as such,             ##
##        and must not be misrepresented as being the original software.      ##
##     4. This notice may not be removed or altered from any source           ##
##        distribution.                                                       ##
##     5. Most important, you must have fun. ;)                               ##
##                                                                            ##
##      Visit opensource.amazingcow.com for more open-source projects.        ##
##                                                                            ##
##                                  Enjoy :)                                  ##
##----------------------------------------------------------------------------##

################################################################################
## Variables                                                                  ##
################################################################################
## One liner to get the fullpath of the current script.
## Thanks to SO user "Dave Dopson"
## http://stackoverflow.com/a/246128
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
BOOTSTRAP_ROOT=$(readlink -f "$SCRIPT_DIR/..");

PROJECT_DIR="$1";
PROJECT_NAME="$2"


################################################################################
## Functions                                                                  ##
################################################################################
rename_helper()
{
    OLD=$1;
    NEW=$2;

    if [ -z "$OLD" ]; then
        echo "[FATAL] Missing SOURCE_NAME."
        exit 1;
    fi;

    if [ -z "$NEW" ]; then
        echo "[FATAL] Missing TARGET_NAME.";
        exit 1;
    fi;

    if [ "$OLD" == "$NEW" ]; then
        echo "[Warning] Same name ($OLD). Skipping";
    fi;

    echo "----> Renaming:"
    echo "      ($OLD)";
    echo "      ($NEW)";
    mv "$OLD" "$NEW";
}

replace_helper()
{
    ITEM=$1;
    TO_BE_REPLACED=$2
    REPlACE_WITH=$3

    if [ -z "$ITEM" ]; then
        echo "[FATAL] Missing FILENAME.";
        exit 1;
    fi;

    if [ -z "$TO_BE_REPLACED" ]; then
        echo "[FATAL] Missing TO_BE_REPLACED.";
        exit 1;
    fi;

    if [ -z "$REPlACE_WITH" ]; then
        echo "[FATAL] Missing REPlACE_WITH.";
        exit 1;
    fi;


    ## Check if the item is an text file.
    FILE_TYPE=$(file "$ITEM");
    IS_ASCII=$(echo $FILE_TYPE | grep "ASCII");

    if [ -z "$IS_ASCII" ]; then
        echo "----> Not ASCII text file. Skipping...";
        echo "      ($ITEM)";
        return;
    fi;

    ## Check if need do anything...
    NEEDS_REPLACE=$(cat "$ITEM" | grep "$TO_BE_REPLACED");
    if [ -z "$NEEDS_REPLACE" ]; then
        echo "----> File doesn't needs to be changed. Skipping...";
        echo "      ($ITEM)";
        return;
    fi;

    ## Replace the contents.
    echo "----> File needs to be changed."
    echo "      ($ITEM)";
    sed --in-place="BACKUP" "s/$TO_BE_REPLACED/$REPlACE_WITH/g" "$ITEM"
    rm "${ITEM}BACKUP";
}

replace_contents()
{
    ITEM=$1;
    TO_BE_REPLACED=$2
    REPlACE_WITH=$3

    #Replace the upper case.
    replace_helper "$ITEM" "$TO_BE_REPLACED" "$REPlACE_WITH";

    #Replace the lower case.
    TO_BE_REPLACED_LOWER=$(echo "$TO_BE_REPLACED" | tr [:upper:] [:lower:]);
    REPLACE_WITH_LOWER=$(  echo "$REPlACE_WITH"   | tr [:upper:] [:lower:]);

    replace_helper "$ITEM" "$TO_BE_REPLACED_LOWER" "$REPLACE_WITH_LOWER"
}


################################################################################
## Script                                                                     ##
################################################################################
## Check if we have the needed info.
if [ -z "$PROJECT_DIR" ]; then
    echo "[FATAL] Missing project dir. Aborting...";
    exit 1;
fi;

if [ -z "$PROJECT_NAME" ]; then
    echo "[FATAL] Missing project name. Aborting...";
    exit 1;
fi;


## Copy all the proj.platform to the project dir.
cp -vr "$BOOTSTRAP_ROOT"/proj/* "$PROJECT_DIR/";

## Change the CWD to ease the operations
cd "$PROJECT_DIR";
pwd;


## Start change the ocurrences of TITLE_PLACEHOLDER to
## the actual project name.
## Change the Filenames.
echo "--> Changing Filenames";
for ITEM in $(find . -not -path '*/\.*' -type f -iname "*TITLE_PLACEHOLDER*"); do
    NEW_NAME=$(echo "$ITEM" | sed "s#TITLE_PLACEHOLDER#$PROJECT_NAME#");
    rename_helper "$ITEM" "$NEW_NAME"
done;

## Change the Foldernames.
echo "--> Changing Foldernames";
for ITEM in $(find . -not -path '*/\.*' -type d -iname "*TITLE_PLACEHOLDER*"); do
    NEW_NAME=$(echo "$ITEM" | sed "s#TITLE_PLACEHOLDER#$PROJECT_NAME#");
    rename_helper $ITEM $NEW_NAME
done;


## Next change the contents of the Files.
for ITEM in $(find . -not -path '*/\.*' -not -path './cocos2d/*' -and -not -path './BootstrapScripts/*' -type f ); do
    replace_contents $ITEM "TITLE_PLACEHOLDER" "$PROJECT_NAME";
done;
