#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Local and remote tests trigger file
#


__INIT__test () {
    
    # read need module files
    source "$MODS/help.sh"
    
    # need 2 paramater for deploy
    if [[ ${#} -ne 2 ]]; then
        __INIT__help
        exit 1;
    fi
    
    # define variables
    local SERVER=$1
    local PROJECT="$2"
    local CONF="$ETC/$PROJECT.conf"
    # local VERSION=$3 # passing deploy functions, not need to define here. 
    
    # exit if config file not exists 
    if [[ ! -f "$CONF" ]]; then
        echo "Config file for $PROJECT doesn't exist. Use 'boss project list' command to see described projects."
        exit 1;
    fi
    
    # source config file
    source $CONF
    
    # Show summary 
    
    ShowTestsSummary ${SERVER} ${PROJECT} `git describe --tag`
    
    case $SERVER in
        
        live|stage )
            RemoteTest
        ;;
        
        local )
            LocalTest
        ;;
        
        * )
            __INIT__help
        ;;
    esac
    
}


LocalTest () {
    echo "--> Test starting"
    ${LOCAL}/${TESTS}
}

RemoteTest () {

    if [[ $SERVER == 'stage' ]]; then
        TESTON='STAGE'
    elif [[ $SERVER == 'live' ]]; then
        TESTON='LIVE'
    else
        echo "${SERVER} is not valid."
        exit 1;
    fi

    TESTON="${TESTON}[@]"
    TESTON=("${!TESTON}")
    
    local REMOTE_PATH=${TESTON[3]}
    
    # Send command to server
    ssh -t -p ${TESTON[2]} ${TESTON[0]}@${TESTON[1]} "bash ${TESTON[3]}/${TESTS}"

}



ShowTestsSummary () {
    echo "=========================================="
    echo "Testing on: ${1}"
    echo "Project: ${2}"
    echo "Version: ${3}"
    echo "=========================================="
}