#!/bin/sh

if [ $LOGNAME != "proap" ]
then
        echo "Please use user \"proap\" to execute."
        exit 0
fi

export CATALINA_HOME=/opt/apache-tomcat
export CATALINA_BASE=${1%/}

echo $CATALINA_BASE

TOMCAT_ID=`ps aux |grep "java"|grep "Dcatalina.base=$CATALINA_BASE "|grep -v "grep"|awk '{ print $2}'`


if [ -n "$TOMCAT_ID" ] ; then
echo "tomcat(${TOMCAT_ITOMCAT_ID}) still running now , please shutdown it first";
    exit 2;
fi

TOMCAT_START_LOG=`$CATALINA_HOME/bin/startup.sh`

if [ "$?" = "0" ]; then
    echo "$0 ${1%/} start success !"
else
    echo "$0 ${1%/} start failed"
    echo $TOMCAT_START_LOG
fi

