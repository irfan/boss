#!/bin/bash
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Uninstall file
#

Uninstall () {
    read -p "This will completely delete all boss script files. Are you sure? [Y/N]: " REMOVE
    
    case $REMOVE in
        y|Y )
            echo "Running with root privileges..";
            `sudo rm -rf /usr/bin/boss $HOME/.boss`
            echo "Done..."
            ;;
        
        * ) echo "Cancelled..." ;;
    esac
}

Uninstall # Call uninstall method