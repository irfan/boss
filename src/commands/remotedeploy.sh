#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Remote deployment file
#

__INIT__remotedeploy () {
    
    # if $2 variable is rollback then call
    # DeployRollBackVersion. It will overwrite 
    # version number and will deploy it.
    
    if [[ ${2} -eq 'rollback' ]]; then
        DeployRollBackVersion ${@}
    else
        DeployNewVersion ${@}
    fi
}




# Function: DeployRollBackVersion
# Get version from .boss/version_old file and 
# start deploy with this version.
# params: 
#   $1    remote server path
#   $2    string 'rollback'     # this will overwrite
#   $3    tag path              # this will overwrite
#   $4    http user and group name
DeployRollBackVersion () {
    echo '--> Rolling back'
    
    local REMOTE_PATH=${1}
    
    if [[ ! -d "${REMOTE_PATH}" && ! -d "${REMOTE_PATH}/.git" ]]; then
        echo "Deployment aborted."
        echo "Because ${REMOTE_PATH} is not a project directory."
        exit 1;
    fi
    
    # go to base path
    cd ${REMOTE_PATH}
    
    # get old version
    
    if [[ ! -f ".boss/version_old" ]]; then
        echo ".boss/version_old file does not exist."
        echo "Please re-deploy which version you would like."
        exit 1;
    fi
    
    local VERSION=`cat .boss/version_old`
    local TAG=".git/refs/tags/$VERSION"
    local REMOTEHTTPUSER=${4}
    
    if [[ ! -f "$TAG"  ]]; then
        echo "Rolling back is aborted."
        echo ".boss/version_old file looking wrong"
        
        exit 1;
    fi
    
    DeployNewVersion ${REMOTE_PATH} ${VERSION} ${TAG} ${REMOTEHTTPUSER}
    
}




# Function: DeployNewVersion
# params: 
#   $1    remote server path
#   $2    version number to deploy
#   $3    tag path
#   $4    http user and group name
DeployNewVersion () {
    
    
    local REMOTE_PATH=${1}
    local VERSION=${2}
    local TAG=${3}
    local REMOTEHTTPUSER=${4}
    local DEPLOYTIME=`date "+%Y-%m-%d_%H-%M-%S"`
    local LOGFILE=.boss/log/deploy_${VERSION}_${DEPLOYTIME}.log
    
    echo '--> Directory changing';
    
    if [[ ! -d "${REMOTE_PATH}" && ! -d "${REMOTE_PATH}/.git" ]]; then
        echo "Deployment aborted."
        echo "Because ${REMOTE_PATH} is not a project directory."
        exit 1;
    fi
    
    # go to base path
    cd ${REMOTE_PATH}
    
    # check .boss directory is exists
    if [[ ! -d ".boss" || ! -d ".boss/log" ]]; then
        echo "--> creating log directory"
        mkdir -p .boss/log
    fi
    
    # create log file
    if [[ ! -f "${LOGFILE}" ]]; then
        touch "${LOGFILE}"
    fi
    
    # move version file. It will created again after deploy succeed.
    if [[ -f .boss/version ]]; then
        mv .boss/version .boss/version_old
    else
        # get current version
        echo `git describe --tag` > .boss/version_old
    fi
    
    
    echo "--> Current version is `git describe --tag`"
    echo "--> Checking uncommitted changes";
    
    STATUS=`git status --ignored -s |grep -e "^[\?|\ M]" | wc -l `
    
    if [[ $STATUS -gt 0 ]]; then
        
        echo "Deployment aborted."
        echo "You have uncommitted changes in your repository."
        echo "Commit or revert your changes and try again."
        
        #move back the version info file
        mv .boss/version_old .boss/version
        
        exit 1
    fi
    
    echo '--> Fetching tags'
    `git fetch --tag >> ${LOGFILE} 2>&1`
    
    echo '--> Pulling with flag'
    `git pull origin master >> ${LOGFILE} 2>&1`
    
    echo '--> Getting new version';
    
    if [[ ! -f ".git/refs/tags/${VERSION}" ]]; then
        
        echo "Deployment aborted."
        echo "Because ${VERSION} is not a valid version"
        echo "To add new version: git tag -a ${VERSION} -m 'Version ${VERSION} relasing'"
        
        #move back the version info file
        mv .boss/version_old .boss/version
        
        exit 1
    fi
    
    `git checkout refs/tags/$VERSION >> ${LOGFILE} 2>&1`
    
    # add the new version
    echo `git describe --tag` > .boss/version
    
    echo '--> Setting permissions'
    `chown -R ${REMOTEHTTPUSER}:${REMOTEHTTPUSER} . >> ${LOGFILE} 2>&1`
    
    echo 'Deployment succeed.'
    echo "Current version is `git describe --tag`"
}


__INIT__remotedeploy ${@}



