#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Deployment module
#

RemoteDeploy () {
    
    if [[ $SERVER == 'stage' ]]; then
        DEPLOYTO='STAGE'
    elif [[ $SERVER == 'live' ]]; then
        DEPLOYTO='LIVE'
    else
        echo "${SERVER} is not valid."
        exit 1;
    fi

    DEPLOYTO="${DEPLOYTO}[@]"
    DEPLOYTO=("${!DEPLOYTO}")
    
    local REMOTE_PATH=${DEPLOYTO[3]}
    
    # Connect to server
    ssh -t -p ${DEPLOYTO[2]} ${DEPLOYTO[0]}@${DEPLOYTO[1]} bash -s < ${COMMANDS}/remotedeploy.sh ${REMOTE_PATH} ${VERSION} ${TAG} ${REMOTEHTTPUSER}
    
    
}


# Uses global variables
# No variable need assign
LocalDeploy () {
    
    bash -s < "${COMMANDS}/localdeploy.sh" ${LOCAL} ${VERSION} ${TAG}
    
}

# Function: __INIT__deploy
# params: 
#   $1    server name
#   $2    project name
#   $3    version number
# Also use;
#   $MODS/help.sh
#   $ETC/$PROJECT.conf

__INIT__deploy () {
    
    # read need module files
    source "$MODS/help.sh"
    
    # need 3 paramater for deploy
    if [[ ${#} -ne 3 ]]; then
        __INIT__help
        exit 1;
    fi
    
    # define variables
    local SERVER=$1
    local PROJECT="$2"
    local CONF="$ETC/$PROJECT.conf"
    local VERSION=$3 # passing deploy functions
    
    # exit if config file not exists 
    if [[ ! -f "$CONF" ]]; then
        echo "Config file for $PROJECT doesn't exist. Use 'boss project list' command to see described projects."
        exit 1;
    fi
    
    # source config file
    source $CONF
    
    # Show summary 
    ShowDeploySummary ${@}
    
    case $SERVER in
        
        live|stage )
            RemoteDeploy ${@}
        ;;
        
        local ) 
            LocalDeploy ${@}
        ;;
        
        * )
            __INIT__help
        ;;
    esac
    
}

ShowDeploySummary () {
    echo "=========================================="
    echo "Deploying to: ${1}"
    echo "Project: ${2}"
    echo "Version: ${3}"
    echo "=========================================="
}