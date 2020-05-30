#!/bin/sh

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

ck_tom=`ps -ef | grep $TOMCAT_ID | wc -l`
if [ $ck_tom != 0 ] ; then
kill -9 $TOMCAT_ID
fi

