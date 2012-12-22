#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Utils
#


# if version is valid then returns 1
#
__version__is__valid () {
    
    local VER=$1
    
    echo `git show-ref | awk '{print $2}' | grep "^refs/tags/"$VER"$" | wc -l | tr -d ' '`

}
