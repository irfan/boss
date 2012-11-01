#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Local deployment file
#

__INIT__localdeploy () {
    local LOCAL=${1}
    local VERSION=${2}
    local TAG=${3}
    
    echo '--> Directory changing';
    
    # Check project directory is whether exists and it is a git repository
    if [[ ! -d "$LOCAL" || ! -d "$LOCAL/.git"  ]]; then
        echo "Deployment aborted."
        echo "Please provide local git path for LOCAL variable in config file";
        exit 1; 
    fi
    
    cd ${LOCAL} &>/dev/null
    
    echo "--> Current version is `git describe --tags`"
    echo '--> Checking uncommitted changes';
    
    # is there any uncommitted file 
    STATUS=`git status --ignored -s |grep -e "^[\?|\ M]" | wc -l `
    
    if [[ $STATUS -gt 0 ]]; then
        echo "Deployment aborted."
        echo "You have uncommitted changes in your repository."
        echo "Commit or revert your changes and try again."
        exit 1
    fi
    
    echo '--> Pulling with flag'
    `git pull origin master  &>/dev/null`
    
    echo '--> Fetching tags'
    `git fetch --tags &>/dev/null`
    
    echo '--> Getting new version';
    
    if [[ ! -f "${TAG}" ]]; then
        echo "Deployment aborted."
        echo "Because ${VERSION} is not a valid version"
        echo "To add new version: git tag -a ${VERSION} -m 'Version ${VERSION} relasing'"
        exit 1
    fi
    
    `git checkout refs/tags/$VERSION &>/dev/null`
    
    echo 'Deployment successed.'
    echo "Current version is `git describe --tags`"
    
}

__INIT__localdeploy ${@}
