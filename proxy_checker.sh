#!/usr/bin/env bash

#!/bin/bash
# ###############################################
# HTTP Proxy Server's IP Address (or URL)
# ###############################################
#
# Example:
# ./proxy_check.sh -p socks5://10.1.0.227:1080 -u http://echoip.com
#

if [[ $# -lt 1 ]]
then
    echo " "
    echo 'No actions passed.'
    echo "Use [$0 --help] for more information"
    exit 0
fi

TYPE='address'
PROXY=''
FILENAME=''
## We're trying to reach this url via the given HTTP Proxy Server
## (http://www.google.com by default)
URL="http://echoip.com"
TIMEOUT=10          ## default request timeout (in seconds)
# ###############################################

function check()
{
    local ADDRESS=$1

    echo -n "$ADDRESS :: "

    # We're fetching the return code and assigning it to the $result variable
    result=`curl -s -o /dev/null -w "%{http_code}" --connect-timeout $TIMEOUT -x $ADDRESS $URL`

    echo -n "CODE $result :: Status "

    # If the return code is 200, we've reached to $url successfully
    if [ "$result" = "200" ]; then
        echo "1"
    # Otherwise, we've got a problem (either the HTTP Proxy Server does not work
    # or the request timed out)
    else
        echo "0"
    fi
}

function check_from_file()
{
    local FILENAME=$1
    if [ ! -f "$FILENAME" ]
    then
        echo "File $FILENAME does not exists"
    fi

    while read address
    do
        check ${address}
    done < "${FILENAME}"
}
# ###############################################
# ###############################################

for i in "$@"
do
    case $i in
    -u|--url)
        URL=$2
        echo $1 $2
        shift 2
        ;;
    -p|--proxy)
        PROXY=$2
        echo $1 $2
        shift 2
        ;;
    -f|--file)
        TYPE='list'
        FILENAME=$2
        shift 2
        ;;
    -t|--timeout)
        TIMEOUT=$2
        shift 2
        ;;

    -h|--help)
        echo "Proxy_checker - check passed proxy address for available"
        echo " "
        echo "./proxy_checker [options] application [arguments]"
        echo " "
        echo "options:"
        echo "-h, --help                show brief help"
        echo "-u, --url=ADDRESS         specify a target url address"
        echo "-p, --proxy=HOST:PORT     specify a proxy address:port to test"
        echo "-f, --file                specify a file with proxy to check"
        echo "-t, --timeout             set timeout for each request (in seconds)"
        exit 0
        ;;
    *)
        ;;
    esac
done


if [ ${TYPE} == 'list' ]
then
    echo "TEST  -- $FILENAME --"
    check_from_file ${FILENAME}
else
    check ${PROXY}
fi

