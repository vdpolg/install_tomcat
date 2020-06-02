#!/bin/bash
#名稱           	版本    日期            作者    備註
#安裝AP tomcat站台	v1.3    20180930        arthur  fix remove folder issue
#			v1.4    20200530        	改單站台
source .TomcatEnv.tmp

WRK_PATH=$PWD #工作路徑
TOM="$(echo $TOMC | sed s/.tar.gz//)" #tomcat 目錄名稱
# 多站台設定(最多3組站台)

#=================新增shell=========START========"
function CTS(){ # Copy Tomcat Shell
cd $WRK_PATH
cp start_tomcat.sh stop_tomcat.sh showui.sh /ap/bin/
}
function MTS(){ # Modify Tomcat Shell
cd $WRK_PATH
cat <<EOF> /ap/bin/start_${TomcatWebName}.sh
if [ \$LOGNAME != "$APNAME" ]
then
        echo "Please use user \"$APNAME\" to execute."
        exit 0
fi

/ap/bin/start_tomcat.sh /ap/${TomcatWebName}

EOF

cat <<EOF> /ap/bin/stop_${TomcatWebName}.sh
if [ \$LOGNAME != "$APNAME" ]
then
        echo "Please use user \"$APNAME\" to execute."
        exit 0
fi

/ap/bin/stop_tomcat.sh /ap/${TomcatWebName}

EOF
mv /ap/bin/showui.sh /ap/bin/show_${TomcatWebName}.sh
cd /ap/bin ;sed -i "s/\$WEBNAME/${TomcatWebName}/g" /ap/bin/show_${TomcatWebName}.sh
chmod g+x *.sh && chown :tomcat *.sh
}
#=================新增shell=========END=========="

        cd /opt/apache-tomcat ; mv ./{conf,temp,work,webapps}  /ap/${TomcatWebName}/  # move tomcat檔案
	rm -rf /opt/apache-tomcat/logs
		
	# server.xml port 設定 
	Serv_P=8005
	Conn_P=8080
	AJP_P=8009
	Redi_P=8443
echo -e "\n================  站台名稱：${TomcatWebName} ===================\n"
echo    "================  Now port setting  ================"
echo -e "================  Server_Port=$Serv_P  ================"
echo -e "================  Connect_Port=$Conn_P  ==============="
echo -e "================  AJP_Port=$AJP_P  ==================="
echo -e "================  Redirect_Port=$Redi_P  ==============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P 
do
grep --color=always $G /ap/${TomcatWebName}/conf/server.xml
done

chown -R $APNAME:tomcat /ap/${TomcatWebName}/
if [ ! -f /ap/bin/start_tomcat.sh ] ;then # 若start_tomcat不存在就新增並修改
		CTS # Copy TomCat Shell function
		MTS # Modify TomCat Shell function
	elif [ ! -f /ap/bin/start_${TomcatWebName}.sh ] ;then #若已存在就新增站台shell
		echo "start_tomcat.sh已存在，新增其他shell" ;sleep 2	
		cd $WRK_PATH
		cp showui.sh /ap/bin/
		MTS # Modify TomCat Shell function
	else
		echo -e "已有重複站台名稱${TomcatWebName}，安裝中止！"
		exit 1
fi

echo -e "\n================  Install Success!  ===============\n"
exit 0

