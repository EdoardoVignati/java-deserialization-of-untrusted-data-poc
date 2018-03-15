#!/bin/bash
#
# ------------------------------------------------------
# Bamboo Startup Script for Unix
# ------------------------------------------------------

displayWarningMessageAndDie() {
    echo ''
    echo ' _   _  __                 _              _   '
    echo '| | / |/ /___ __ __ _ __  (_) __  ___    / /  '
    echo '| |/  / / _  `/ `_// `_ \/ / `_ \/   \  / /   '
    echo '|  /|  / /_/ / /` / / / / / / / / () / /_/    '
    echo '|_/ |_/\__,_/_/  /_/ /_/_/_/ /_/\_, / (_)     '
    echo '                               |___/          '
    echo ''
    echo "$1"
    echo ''
    echo "Bamboo.sh has been deprecated since Bamboo 5.1. For more details please see"
    echo 'https://confluence.atlassian.com/display/BAMBOO/Bamboo+5.1+Upgrade+Guide'
    echo ''

    exit -1
}

[ $# -gt 0 ] || displayWarningMessageAndDie

#
# Get the action & configs
#
ACTION=$1

#
# Do the action
#
case "$ACTION" in
  start)
        displayWarningMessageAndDie "Bamboo has been not started!"
        ;;

  console)
        displayWarningMessageAndDie "Bamboo has been not started!"
        ;;
  
  stop)
        displayWarningMessageAndDie "Bamboo has been not stopped!"
        ;;

  restart)
        displayWarningMessageAndDie "Bamboo has been not restarted!"
        ;;

  status)
        displayWarningMessageAndDie 
        ;;

*)
        usage
        ;;
esac

exit 0
