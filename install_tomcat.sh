#!/bin/bash
#名稱           版本    日期            作者    備註
#安裝tomcat     v1      20180830        arthur 
#	        v1.1    20180830        arthur  全新改款 tomcat_ui

WRK_PATH=$PWD
DAT=$(date +%Y%m%d-%H%M%S)
if [[ $# == 0 ]] ; then
if [[ -d `ls -d /opt/apache-tomcat` ]] 2> /dev/null ; then
echo -n "已存在 `ls -d /opt/apache-tomcat` 是否繼續安裝？(y/n) "  ;read YN
	if [[ $YN = Y || $YN = y ]]; then
	echo -e "OK!繼續安裝 \n"
#	重複安裝先備份檔案	
	cd /opt; tar zcvf apache-tomcat-${DAT}.tar.gz apache-tomcat 
#	mv apache-tomcat old_apache-tomcat
	rm -rf apache-tomcat 
	else
	echo -e "待確認後再執行，離開安裝程式! \n"
	exit 1
	fi
else
echo -n "First Installing" ;sleep 1
echo -n " ." ;sleep 1
echo -n "." ;sleep 1
echo "."

fi
		TOMC="apache-tomcat-8.0.53.tar.gz"
                echo '========安裝Tomcat 8.0.53========='
                sleep 1
		cd $WRK_PATH
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
		mv conf/ webapps/ temp/ work/ -t /ap/tomcat_ui/
		chown -R proap:proap /ap/tomcat_ui

#		建log的soft link
		if [[ -d /log/tomcat_ui ]] ; then
		echo -en "==logs folder 已存在," ; sleep 1 
		echo -e "故/ap/tomcat_ui/logs 維持不變== \n"
		else
		mkdir -p /log/tomcat_ui
		ln -sf /log/tomcat_ui /ap/tomcat_ui/logs
		fi
		chown -R proap:proap /log/tomcat_ui
                rm -rf /opt/$TOMC
                echo -e "==Tomcat install Success!== \n"

else
# 多站台設定(最多3組站台)
# 站台名稱
APName=$1
# 站台數量 0~2
APCount=$2
# example 
echo "USE command --> : $0 <ap name> <0~2>"

if [[ -d `ls -d /opt/apache-tomcat` ]] 2> /dev/null ; then
echo -n "已存在 `ls -d /opt/apache-tomcat` 是否繼續安裝？(y/n) "  ;read YN
	if [[ $YN = Y || $YN = y ]]; then
	echo -e "OK!繼續安裝 \n"
#	重複安裝先備份檔案	
	cd /opt; tar zcvf apache-tomcat-${DAT}.tar.gz apache-tomcat 
	rm -rf apache-tomcat 
	else
	echo -e "待確認後再執行，離開安裝程式! \n"
	exit 1
	fi
else
echo -n "First Installing" ;sleep 1
echo -n " ." ;sleep 1
echo -n "." ;sleep 1
echo "."

fi
		TOMC="apache-tomcat-8.0.53.tar.gz"
                echo '========安裝Tomcat 8.0.53========='
                sleep 1
		cd $WRK_PATH
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
                mkdir -p /ap/${APName} ; 
		cd /opt/apache-tomcat

#		搬移tomcat 和複製檔案
		mv conf/ webapps/ temp/ work/ -t /ap/${APName}/
		chown -R proap:proap /ap/${APName}

#		建log的soft link
		if [[ -d /log/${APName} ]] ; then
		echo -en "==logs folder 已存在," ; sleep 1 
		echo -e "故/ap/tomcat_ui/logs 維持不變== \n"
		else
		mkdir -p /log/${APName}
		ln -sf /log/${APName} /ap/${APName}/logs
		fi
		chown -R proap:proap /log/${APName}
                rm -rf /opt/$TOMC
                echo -e "==Tomcat install Success!== \n"
# xml port 設定 
Serv_P=8005
Conn_P=8080
AJP_P=8009
Redi_P=8443

case $APCount in
0)echo "預設值0"
echo    "================  Now port setting  =================="
echo -e "================  Server_Port=$Serv_P  ================"
echo -e "================  Connect_Port=$Conn_P  ==============="
echo -e "================  AJP_Port=$AJP_P  ==================="
echo -e "================  Redirect_Port=$Redi_P  ==============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P 
do
grep --color=always $G /ap/${APName}/conf/server.xml
done
;;
1)echo "你已輸入1(在預設值+10)"
echo $Serv_P |awk '{print $1+10}'
echo    "================  Now port setting   =================="
echo -e "================  Server_Port  =  `echo $Serv_P|awk '{print $1+10}'`  ==============="
echo -e "================  Connect_Port =  `echo $Conn_P|awk '{print $1+10}'`  ==============="
echo -e "================  AJP_Port     =  `echo $AJP_P|awk '{print $1+10}'`  ==============="
echo -e "================  Redirect_Port=  `echo $Redi_P|awk '{print $1+10}'`  ===============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P
do
#sed -i s/$G/`expr $G + 10`/g /ap/${APName}/conf/server.xml
sed -i s/$G/`echo $G |awk '{print $1+10}'`/g /ap/${APName}/conf/server.xml
grep --color=always `echo $G |awk '{print $1+10}'` /ap/${APName}/conf/server.xml
done
;;
2)echo "你已輸入2(預設值+20)"
echo $Serv_P |awk '{print $1+20}'
echo    "================  Now port setting   =================="
echo -e "================  Server_Port  =  `echo $Serv_P|awk '{print $1+20}'`  ==============="
echo -e "================  Connect_Port =  `echo $Conn_P|awk '{print $1+20}'`  ==============="
echo -e "================  AJP_Port     =  `echo $AJP_P|awk '{print $1+20}'`  ==============="
echo -e "================  Redirect_Port=  `echo $Redi_P|awk '{print $1+20}'`  ===============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P
do
sed -i s/$G/`echo $G |awk '{print $1+20}'`/g /ap/${APName}/conf/server.xml
grep --color=always `echo $G |awk '{print $1+20}'` /ap/${APName}/conf/server.xml
done

;;
*) echo 請輸入0~2的數字;;
esac
fi

#剩文件step7 ......

#安裝JavaJDK
#cd /soures/software
#rpm -ivh jdk-7u79-linux-x64.rpm
#java -version

