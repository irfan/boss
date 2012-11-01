#
#
# boss is a script which is helpful during deployment of web projects
# Author: Irfan Durmus
# http://github.com/irfan/boss
#
# Help module
#

InstallationHelp () {
    cat doc/installation.txt
}

__INIT__help () {
    if [[ -f "doc/usage.txt" ]]; then
        cat "doc/usage.txt"
    else
        cat "$DOC/usage.txt"
    fi
}

