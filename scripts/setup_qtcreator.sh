#!/bin/bash
##----------------------------------------------------------------------------##
##               █      █                                                     ##
##               ████████                                                     ##
##             ██        ██                                                   ##
##            ███  █  █  ███        setup_qtcreator.sh                        ##
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
QT_FILES="./qtcreator_files";

PROJECT_DIR="$1";
PROJECT_NAME="$2"
PROJECT_ABS_DIR=$(readlink -f "$PROJECT_DIR");

FILE_DOT_CREATOR_USER="$PROJECT_NAME.creator.user";
FILE_DOT_INCLUDES="$PROJECT_NAME.includes";
FILE_DOT_FILES="$PROJECT_NAME.files";


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

## Copy the files to the Project directory.
cd "$SCRIPT_DIR";
cp -vr "$QT_FILES"/* "$PROJECT_DIR";

## Rename the copied files
##  So they will have the same name as the project.
cd "$PROJECT_DIR";
for QTFILE in $(ls -1 QT_CREATOR_PROJECT*); do
    NEW_NAME=$(echo $QTFILE | sed s/QT_CREATOR_PROJECT/$PROJECT_NAME/g);
    mv -v $QTFILE $NEW_NAME;
done;

## Finally replace the Path in the .creator.user file.
sed -iBACK "s#QT_CREATOR_PROJECT_PATH#$PROJECT_ABS_DIR#g" "$FILE_DOT_CREATOR_USER"
rm -rfv *BACK
sed -iBACK "s#QT_CREATOR_EXEC_PATH#$PROJECT_ABS_DIR/bin/debug/linux/$PROJECT_NAME#g" "$FILE_DOT_CREATOR_USER"
rm -rfv *BACK

## Now we need fill the .includes and .files files with the directories and
## files of the project.
cd "$PROJECT_DIR";
find . -not -path '*/\.*' -type d >> "$FILE_DOT_INCLUDES";
find . -not -path '*/\.*' -type f >> "$FILE_DOT_FILES";
