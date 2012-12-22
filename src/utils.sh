#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Utils
#

__is__tag__valid () {
    
    local VER=$1
    
    echo `git show-ref | awk '{print $2}' | grep "^refs/tags/"$VER"$" | wc -l | tr -d ' '`

}
