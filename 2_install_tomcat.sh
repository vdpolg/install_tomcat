#!/bin/bash
#名稱           版本    日期            作者    備註
#安裝tomcat     v1      20180830        arthur 
#	        v1.1    20200530

# export env 
source .TomcatEnv.tmp

TOMC=$1

TOM="$(echo $TOMC | sed s/.tar.gz//)" #tomcat 目錄名稱

# check tomcat file
if [[ $# == 0 ]] ; then

echo ''
echo -e "need "\<*tar.gz\>" and "\<*tar.gz.sha512\>" file \n"

echo -e "  $0 apache-tomcat-8.x.x.tar.gz apache-tomcat-8.x.x.tar.gz.sha512 \n"
exit 1
fi

if [[ -d `ls -d /opt/apache-tomcat*` ]] 2> /dev/null ; then
echo -n "已存在 `ls -d /opt/apache-tomcat* ` 是否繼續安裝？(y/n) "  ;read YN
	if [[ $YN = Y || $YN = y ]]; then
	echo -e "OK!繼續安裝 \n"

	else
	echo -e "待確認後再執行，離開安裝程式! \n"
	exit 1
	fi
else
echo "繼續安裝"
fi
echo -e "========安裝 $1 ========="
sleep 1
sha512sum -c $2 > /dev/null

	if [[ $? == 0 ]] ; then
	echo "驗證成功，繼續安裝"
	else
	echo "驗證失敗，請洽系統人員!"
	exit 1
	fi

tar zxvf $TOMC -C /opt/
mv /opt/$TOM /opt/apache-tomcat && chown -R :tomcat /opt/apache-tomcat
echo -e "\n===    Success!     ===\n"
echo "TOMC=$1" >> .TomcatEnv.tmp
exit 0
