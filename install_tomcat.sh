#!/bin/bash
#名稱           版本    日期            作者    備註
#安裝tomcat     v1      20180830        arthur 
TOMC="apache-tomcat-8.0.53.tar.gz" #tomcat 安裝檔
TOM="$(echo $TOMC | sed s/.tar.gz//)" #tomcat 目錄名稱

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
echo '========安裝Tomcat 8.0.53========='
sleep 1
sha512sum -c ${TOMC}.sha512 > /dev/null

	if [[ `echo $?` == 0 ]] ; then
	echo "驗證成功，繼續安裝"
	else
	echo "驗證失敗，請洽系統人員!"
	exit 1
	fi

cp $TOMC /opt/
cd /opt;tar zxvf $TOMC
mv $TOM /opt/apache-tomcat
chown -R proap:proap /opt/apache-tomcat
rm -rf /opt/$TOMC
echo "==Success!=="

