#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Config user interface and write
#


WriteConfigFile () {
    
    if [[ ${#DES} -gt 2 ]]; then
        CONFBASE="${DES}"
    else
        CONFBASE="${BOSS_PATH}"
    fi

echo 'Writing config file...'
echo ''
echo "# Boss project config file
#
# Config file for the $PROJECT project's.
# 

PROJECT=\"$PROJECT\"
TYPE=\"$TYPE\"

ORIGIN=\"$ORIGIN\"
LOCAL=\"$LOCAL\"

# Remote server's http username
REMOTEHTTPUSER=\"$REMOTEHTTPUSER\"

# test script path and parameters 
TESTS=\"${TESTS}\"

# stage server username
STAGE[0]=\"${STAGE[0]}\"

# stage server hostname or IP
STAGE[1]=\"${STAGE[1]}\"

# stage server port 
STAGE[2]=\"${STAGE[2]}\"

# git repository full path of the stage server
STAGE[3]=\"${STAGE[3]}\"


# live server username
LIVE[0]=\"${LIVE[0]}\"

# live server hostname or IP
LIVE[1]=\"${LIVE[1]}\"

# live server port 
LIVE[2]=\"${LIVE[2]}\"

# git repository full path of the live server
LIVE[3]=\"${LIVE[3]}\"

" >> "${CONFBASE}/etc/${PROJECT}.conf"

}

#
# Get information;
# ORIGIN, LOCAL, STAGE, LIVE servers' git path and what is machine for this installation? 
#

GetConfig () {
    
    echo ''
    echo 'Please give a name of your project; '
    read -p "[myproject]: " PROJECT
    
    echo ''
    echo 'Enter your repository origin path; '
    read -p "[e.g: git@github.com:irfan/boss.git]: " ORIGIN

    echo ''
    echo 'Enter your local git repository path;'
    read -p "[e.g: /home/irfan/projects/mysite]: " LOCAL
    
    echo ''
    echo 'Enter your stage server information;'
    read -p "[username]     : " USER
    read -p "[server]       : " SERVER
    read -p "[server port]  : " PORT
    read -p "[repo path]    : " REPOPATH
    
    STAGE=([0]="$USER" [1]="$SERVER" [2]="$PORT" [3]="$REPOPATH")
    unset USER SERVER PORT REPOPATH
    
    echo ''
    echo 'Enter your live server information;'
    read -p "[username]     : " USER
    read -p "[server]       : " SERVER
    read -p "[server port]  : " PORT
    read -p "[repo path]    : " REPOPATH

    LIVE=([0]="$USER" [1]="$SERVER" [2]="$PORT" [3]="$REPOPATH")
    unset USER SERVER PORT REPOPATH
    
    echo ''
    echo 'Please give remote http user;'
    read -p "[e.g: www|www-data|apache2]: " REMOTEHTTPUSER
    
    echo ''
    echo 'Please provide tests script path and parameters under project path:'
    read -p "[e.g: tests/tests.sh --start=frontend backend]: " TESTS
    
    echo ''
    echo 'What is this machine for'
    read -p "[e.g: development/stage/live] ?: " TYPE

}
