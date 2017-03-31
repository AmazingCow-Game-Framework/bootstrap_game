#!/bin/bash
##----------------------------------------------------------------------------##
##               █      █                                                     ##
##               ████████                                                     ##
##             ██        ██                                                   ##
##            ███  █  █  ███        compile.sh                                ##
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
## Vars                                                                       ##
################################################################################
SCRIPT_DIR="CCH";
CURRENT_DIR=$(pwd)
GAME_NAME="PROJECT_NAME_PLACEHOLDER"

IS_TO_COPY_RESOURCES="0";
IS_TO_UPDATE_BUILD_NO="0";


################################################################################
## Update the Game Sources                                                    ##
################################################################################
find ./Sources -iname "*.c*" |  \
sed 's/\.\///g'              >  \
./compile_definitions/game_sources.txt


################################################################################
## Copy the Resources                                                         ##
################################################################################
if [ "$IS_TO_COPY_RESOURCES" != "0" ]; then
    ./copy_resources.sh
fi;


################################################################################
## Update the Build Number                                                    ##
################################################################################
if [ "$IS_TO_UPDATE_BUILD_NO" != "0" ]; then
    ./update_build_no.sh
fi;


################################################################################
## CMAKE                                                                      ##
################################################################################
$SCRIPT_DIR/update_cmake.py                                                    \
    --game-name=$GAME_NAME                                                     \
    --working-dir=$CURRENT_DIR                                                 \
    --game-sources=$CURRENT_DIR/compile_definitions/game_sources.txt           \
    --include-dirs=$CURRENT_DIR/compile_definitions/include_directories.txt    \
    --android-defs=$CURRENT_DIR/compile_definitions/android_definitions.txt    \
    --linux-defs=$CURRENT_DIR/compile_definitions/linux_definitions.txt

if [ "$?" != "0" ]; then
    echo "Update CMakeLists.txt error.";
    exit 1;
fi;


################################################################################
## Android MK                                                                 ##
################################################################################
$SCRIPT_DIR/update_androidmk.py                                                \
    --game-name=$GAME_NAME                                                     \
    --working-dir=$CURRENT_DIR/                                                \
    --game-sources=$CURRENT_DIR/compile_definitions/game_sources.txt           \
    --include-dirs=$CURRENT_DIR/compile_definitions/include_directories.txt    \

if [ "$?" != "0" ]; then
    echo "Update Android.mk error.";
    exit 1;
fi;


################################################################################
## Compile                                                                    ##
################################################################################
$SCRIPT_DIR/compilecocos.sh $@
