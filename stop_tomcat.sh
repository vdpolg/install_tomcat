#!/bin/sh

if [ $LOGNAME != "proap" ]
then
        echo "Please use user \"proap\" to execute."
        exit 0
fi

export CATALINA_HOME=/opt/apache-tomcat
export CATALINA_BASE=${1%/}

echo $CATALINA_BASE

TOMCAT_ID=`ps aux |grep "java"|grep "[D]catalina.base=$CATALINA_BASE "|awk '{ print $2}'`

if [ -n "$TOMCAT_ID" ] ; then
TOMCAT_STOP_LOG=`$CATALINA_HOME/bin/shutdown.sh`
else
    echo "Tomcat instance not found : ${1%/}"
    exit
fi

if [ "$?" = "0" ]; then
    echo "$0 ${1%/} stop succeess !"
else
    echo "$0 ${1%/} stop failed"
    echo $TOMCAT_STOP_LOG
fi

