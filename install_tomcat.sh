#!/bin/bash
#名稱           版本    日期            作者    備註
#安裝tomcat     v1      20180830        arthur 
#	        v1.1    20180830        arthur  全新改款 tomcat_ui
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
		TOMC="apache-tomcat-8.0.53.tar.gz"
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
                cd /opt;tar zxvf $TOMC && mv $(echo $TOMC | sed s/.tar.gz//) apache-tomcat
		chown -R proap:proap apache-tomcat
#		建AP目錄
                mkdir -p /ap/tomcat_ui ; 
		cd /opt/apache-tomcat
#		搬移tomcat 和複製檔案
		mv conf/ webapps/ temp/ logs/ work/ -t /ap/tomcat_ui/
#第二台才會用到	cp -pr /ap/tomcat_ui/* /ap/tomcat_cm/
		chown -R proap:proap /ap/tomcat_ui
#		建log的soft link
		mkdir -p tomcat_ui ; mv /ap/tomcat_ui/logs /log/tomcat_ui
		ln -s /log/tomcat_ui /ap/tomcat_ui/logs
                rm -rf /opt/$TOMC
                echo "==Success!=="
#剩文件step7 ......

#安裝JavaJDK
#cd /soures/software
#rpm -ivh jdk-7u79-linux-x64.rpm
#java -version

