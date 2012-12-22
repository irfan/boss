#!/bin/bash
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Main file
#


__INIT__boss () {
    
    local BOSS_PATH=`readlink $0`
    local BOSS_PATH=`dirname $BOSS_PATH`
    local BOSS_PATH=`dirname $BOSS_PATH`
    
    local ETC=$BOSS_PATH'/etc'
    local DOC=$BOSS_PATH'/doc'
    local SRC=$BOSS_PATH'/src'
    local MODS=$BOSS_PATH'/src/mods'
    local COMMANDS=$BOSS_PATH'/src/commands'
    
    case $1 in
        help|test|deploy|rollback|project )
            
            MOD=$1
            shift
            source "$MODS/$MOD.sh"
            __INIT__$MOD ${@}
            ;;
        * )
            shift
            source "$MODS/help.sh"
            __INIT__help ${@}
            ;;
    esac
    
}

# call the main method 
__INIT__boss ${@}
