#!/bin/bash

set -e

while getopts ":n" OPT ; do
    case $OPT in
        n) NOBUILD=1 ;;
    esac
done

echo "Please enter https://releases.1c.ru/ credentials"
IFS=""
read -r -p "Login: " USERNAME
read -r -s -p "Password: " PASSWORD; echo
read -r -p "Version: " VERSION

export USERNAME
export PASSWORD
export VERSION

./download.sh
if [ -z "$NOBUILD" ] ; then
    ./build.sh
fi
