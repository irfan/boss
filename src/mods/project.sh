#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Project module
#

__INIT__project () {
    
    local ACTION=$1;
    source ${MODS}/help.sh
    
    case ${ACTION} in
        
        add )
            AddProject ${@} ;;
        
        list )
            ListProject ${@} ;;
        
        remove )
            RemoveProject ${@} ;;
        
        * )
            __INIT__help ${@} ;;
    esac
    
    
}


AddProject () {
    
    source "${SRC}/config.sh"

    # Ask for config
    GetConfig

    # Write config file
    WriteConfigFile

    # Show usage
    __INIT__help


}


ListProject () {
    
    for i in `ls $ETC | grep -v boss.example.conf | sed -e 's|\.conf$||'`; do
        echo " - $i";
    done
}


RemoveProject () {
    
    COUNT=${#}
    CONF="$ETC/$2.conf"
    PROJ="${2}"
    
    # if no enough argument show help
    if [[ $COUNT -ne 2 ]]; then
        __INIT__help ${@}
        
        exit 1;
    fi
    
    # if project not exists show error and project list
    if [[ ! -f $CONF ]]; then
        
        echo "--> ${PROJ} is not a project."
        echo "Project List:"
        ListProject ${@}
        exit 1;
    fi
    
    rm -rf "${CONF}"
    echo "--> \"$PROJ\" removed"
    
    
}




