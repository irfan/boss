#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Rollback deployment
#

__INIT__rollback () {
    
    # start deployment with rollback version.
    # rollback version means deploy previous version.
    # previous version's number reading from .boss/version_old on server.
    
    source ${MODS}/deploy.sh
    
    __INIT__deploy ${@} 'rollback'
    
}
