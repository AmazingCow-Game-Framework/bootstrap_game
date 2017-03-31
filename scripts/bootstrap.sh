#!/bin/bash
##----------------------------------------------------------------------------##
##               █      █                                                     ##
##               ████████                                                     ##
##             ██        ██                                                   ##
##            ███  █  █  ███        bootstap.sh                               ##
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
## Functions                                                                  ##
################################################################################
find_script_dir()
{
    local SCRIPT_SRC="${BASH_SOURCE[0]}"
    local SCRIPT_DIR="";

    while [ -h "$SCRIPT_SRC" ]; do
        SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SRC" )" && pwd )"
        SCRIPT_SRC="$(readlink "$SCRIPT_SRC")"
        [[ $SCRIPT_SRC != /* ]] && SCRIPT_SRC="$SCRIPT_DIR/$SCRIPT_SRC"
    done;
    SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SRC" )" && pwd )"

    echo $SCRIPT_DIR;
}

################################################################################
## Variables                                                                  ##
################################################################################
PROJECT_NAME="$1";
SCRIPT_DIR=$(find_script_dir);
PROJECT_DIR=$(pwd);

################################################################################
## Script                                                                     ##
################################################################################
echo $SCRIPT_DIR;
echo $PROJECT_DIR;

## Check if we have a valid project name.
if [ -z "$PROJECT_NAME" ]; then
    echo "Missing project name. Aborting...";
    exit 1;
fi;


## Change the CWD to project directory to ease the operations.
cd "$PROJECT_DIR";

## Initialize git if not already initialized.
git status;
if [ $? != 0 ]; then
    git init;
fi;


## Call the bootstrap sequence.
$SCRIPT_DIR/create_dirs.sh            "$PROJECT_DIR"                  && \
$SCRIPT_DIR/clone_amazingcow_libs.sh  "$PROJECT_DIR"                  && \
$SCRIPT_DIR/clone_cocos2dx.sh         "$PROJECT_DIR"                  && \
$SCRIPT_DIR/setup_cch.sh              "$PROJECT_DIR" "$PROJECT_NAME"  && \
$SCRIPT_DIR/setup_projs.sh            "$PROJECT_DIR" "$PROJECT_NAME"  && \
$SCRIPT_DIR/setup_qtcreator.sh        "$PROJECT_DIR" "$PROJECT_NAME"  && \
$SCRIPT_DIR/create_info_files.sh      "$PROJECT_DIR" "$PROJECT_NAME"  && \
$SCRIPT_DIR/copy_cocos_meta.sh        "$PROJECT_DIR"


## Make the first commit.
git add .;
git commit -m "[BOOTSTRAP_GAME INIT]";
