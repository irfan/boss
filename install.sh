#!/bin/bash
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Installation file
#

__INIT__install () {
    
    GIT=`whereis git`;
    DES="$HOME/.boss";
    SRC="./src"
    ETC="./etc"
    DOC="./doc"
    
    source src/mods/help.sh
    source src/config.sh
    
    InstallationHelp    # Show installation help
    
    read -p "Do you want to continue to installation? [Y/N] : " INSTALLAPPROVE
    
    case $INSTALLAPPROVE in
        y|Y )
            echo ''
            continue;;
        * )
            echo ''
            exit 1 ;;
    esac
    
    # Check git is whether installed
    test ! ${#GIT} -gt 1 && (echo "Please install git"; exit 1; )
    
    # If already installed remove the old one
    test -d $DES && (echo "-->" $DES "removing.."; rm -fr $DES; )
    
    # Create installation directory
    test ! -d $DES && (echo "-->" $DES "creating.."; mkdir $DES; )
    
    # Copy boss files
    echo "--> Copying folders: src, etc and doc -> $DES"
    echo "--> ./src > $DES"
    `cp -R $SRC $DES/`
    echo "--> ./etc > $DES"
    `cp -R $ETC $DES/`
    echo "--> ./doc > $DES"
    `cp -R $DOC $DES/`
    echo "--> Done!"
    
    # create symbolic link
    echo "--> Symbolic link creating with root privileges.."
    `sudo ln -sf $DES/src/boss.sh /usr/bin/boss`
    
    # Set up permissions
    echo "--> Setting up permissions.."
    `chmod -R u+x $DES`
    
    # if couldn't create the link show error message
    test ! -h "/usr/bin/boss" && ( echo "--> symbolic link could not created!"; exit 1;);
    
    # Ask for config
    GetConfig
    
    # Write config file
    WriteConfigFile
    
    # Show usage
    __INIT__help
    
}

# Call the install method
__INIT__install

