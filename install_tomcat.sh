#!/bin/bash
#名稱           版本    日期            作者    備註
#安裝tomcat     v1      20180830        arthur 
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
                cd /opt;tar zxvf $TOMC
                cd apache-tomcat-* ;  rm -rf webapps
                mkdir -p /ap/deploy-tomcat ; ln -sf /ap/deploy-tomcat/ /opt/$(echo $TOMC | sed s/.tar.gz//)/webapps
                chown -R proap:proap /ap
                rm -rf /opt/$TOMC
                echo "==Success!=="

#安裝JavaJDK
#cd /soures/software
#rpm -ivh jdk-7u79-linux-x64.rpm
#java -version
