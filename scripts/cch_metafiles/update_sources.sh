#!/bin/bash
##----------------------------------------------------------------------------##
##               █      █                                                     ##
##               ████████                                                     ##
##             ██        ██                                                   ##
##            ███  █  █  ███        update_sources.sh                         ##
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
DEFINITIONS_DIR="compile_definitions";

ALL_SOURCES=$(find ./Sources -iname "*.c*");
TO_EXCLUDE=$(cat $DEFINITIONS_DIR/paths_to_exclude_from_compile.txt);
EXCLUDED_SOURCES="";

################################################################################
## Script                                                                     ##
################################################################################
## Clean up the previous sources.
echo "" > "$DEFINITIONS_DIR/game_sources.txt"

## Find all sources files and check if them aren't
## to be exclude. If not add them to the game_sources.txt
for FILENAME in $ALL_SOURCES; do
    for EXCLUDE in $TO_EXCLUDE; do
        MATCH=$(echo $FILENAME | fgrep $EXCLUDE);
        if [ -z $MATCH ]; then
            echo $FILENAME >> "$DEFINITIONS_DIR/game_sources.txt";
            break;
        else
            EXCLUDED_SOURCES+="$MATCH ";
        fi;
    done;
done;


## Log the excluded sources...
echo "Excluded sources:"
for FILENAME in $EXCLUDED_SOURCES; do
    echo $FILENAME;
done;
