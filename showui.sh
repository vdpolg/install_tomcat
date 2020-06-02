#!/bin/bash

typeset -i jpd_coun=`ps -ef | grep $WEBNAME | grep java | grep -v grep | wc -l`
if [[ $jpd_coun == "0" ]] ; then
    printf "\E[0;31;40m"   #red
    echo -e "$WEBNAME is Not Running"
        else
            printf "\E[0;32;40m"   #green
            echo -e "$WEBNAME is Running"
fi

printf "\E[0m"   #white

exit 0

