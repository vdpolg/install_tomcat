#!/bin/bash
#名稱           	版本    日期            作者    備註
#安裝AP tomcat站台	v1.3    20180930        arthur  fix remove folder issue
#			v1.4    20200530        	建構中，還不能用
if [ $LOGNAME != "proap" ]
then
        echo "Please use user \"proap\" to execute."
        exit 0
fi

WRK_PATH=$PWD #工作路徑
DAT=$(date +%Y%m%d-%H%M%S) #timestamp 暫時用不到
TOMC="apache-tomcat-8.0.53.tar.gz" #tomcat 安裝檔
TOM="$(echo $TOMC | sed s/.tar.gz//)" #tomcat 目錄名稱
# 多站台設定(最多3組站台)
APName=$1	# 站台名稱
APCount=$2	# 站台序號 0~2

function var2(){ #最多能建立3個站台,序號0~2
  echo "請輸入<站台名稱>及<站台序號> 0~2"
  echo "Usage command --> : $0 <ap name> <0~2>"
  echo -e "安裝中止！ \n"
  exit 1
}
#=================新增shell=========START========"
function CTS(){ # Copy Tomcat Shell
cd $WRK_PATH
cp start_tomcat.sh stop_tomcat.sh showui.sh /ap/bin/
}
function MTS(){ # Modify Tomcat Shell
cd $WRK_PATH
echo "/ap/bin/start_tomcat.sh /ap/${TomcatWebName}" > /ap/bin/start_${TomcatWebName}.sh
echo "/ap/bin/stop_tomcat.sh /ap/${TomcatWebName}" > /ap/bin/stop_${TomcatWebName}.sh
mv /ap/bin/showui.sh /ap/bin/show_${TomcatWebName}.sh
cd /ap/bin ;sed -i "s/$WEBNAME/${TomcatWebName}/g" /ap/bin/show_${TomcatWebName}.sh
#chmod u+x start_${TomcatWebName}.sh stop_${TomcatWebName}.sh
chmod u+x *.sh
chown proap:proap start_${TomcatWebName}.sh stop_${TomcatWebName}.sh
}
#=================新增shell=========END=========="

if [[ $# != 2 ]] ; then  #1 check 變數只能2個
var2
elif [[ $APCount != 0 ]] && [[ $APCount != 1 ]] && [[ $APCount != 2 ]]; then #1 check 站台序號只能 0~2 
var2
else #1
  echo -e "Installing" ;sleep 3

  if [[ -d `ls -d /opt/apache-tomcat` ]] 2> /dev/null ; then #2 若tomcat 存在就install 
    cd /opt ;rm -rf apache-tomcat/* #清除舊檔
    echo -e '========安裝$(echo $TOMC | sed s/.tar.gz//)========= \n'
    sleep 1
    cd $WRK_PATH
    sha512sum -c ${TOMC}.sha512 > /dev/null
      if [[ `echo $?` == 0 ]] ; then #3 checksum 安裝檔有效性
        echo "驗證成功，繼續安裝"
	    #解tar 並copy & rename至/opt
        tar zxvf $TOMC 
	cd $TOM; cp -pr $(ls|egrep -v '(logs|webapps|work|conf|temp)') /opt/apache-tomcat
        chown -R proap:proap /opt/apache-tomcat 
	mkdir -p /ap/${TomcatWebName} #建AP目錄
        cd $WRK_PATH ; cp -pr $TOM/{conf,temp,work,webapps} -t /ap/${TomcatWebName}/  #複製tomcat檔案
        chown -R proap:proap /ap/${TomcatWebName}
	rm -rf $WRK_PATH/$TOM #裝完移除資料
		
	# server.xml port 設定 
	Serv_P=8005
	Conn_P=8080
	AJP_P=8009
	Redi_P=8443
case $APCount in
0)echo -e "\n ====  站台名稱：${TomcatWebName} ，這是第${APCount}站台(預設值) ====\n"
echo    "================  Now port setting  =================="
echo -e "================  Server_Port=$Serv_P  ================"
echo -e "================  Connect_Port=$Conn_P  ==============="
echo -e "================  AJP_Port=$AJP_P  ==================="
echo -e "================  Redirect_Port=$Redi_P  ==============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P 
do
grep --color=always $G /ap/${TomcatWebName}/conf/server.xml
done
;;
1)echo -e "\n ====  站台名稱：${TomcatWebName} ，這是第${APCount}站台(預設port+10) ====\n"
echo    "================  Now port setting   =================="
echo -e "================  Server_Port  =  `echo $Serv_P|awk '{print $1+10}'`  ==============="
echo -e "================  Connect_Port =  `echo $Conn_P|awk '{print $1+10}'`  ==============="
echo -e "================  AJP_Port     =  `echo $AJP_P|awk '{print $1+10}'`  ==============="
echo -e "================  Redirect_Port=  `echo $Redi_P|awk '{print $1+10}'`  ===============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P
do
sed -i s/$G/`echo $G |awk '{print $1+10}'`/g /ap/${TomcatWebName}/conf/server.xml
grep --color=always `echo $G |awk '{print $1+10}'` /ap/${TomcatWebName}/conf/server.xml
done
;;
2)echo -e "\n ====  站台名稱：${TomcatWebName} ，這是第${APCount}站台(預設port+20) ====\n"
echo    "================  Now port setting   =================="
echo -e "================  Server_Port  =  `echo $Serv_P|awk '{print $1+20}'`  ==============="
echo -e "================  Connect_Port =  `echo $Conn_P|awk '{print $1+20}'`  ==============="
echo -e "================  AJP_Port     =  `echo $AJP_P|awk '{print $1+20}'`  ==============="
echo -e "================  Redirect_Port=  `echo $Redi_P|awk '{print $1+20}'`  ===============\n"
for G in $Serv_P $Conn_P $AJP_P $Redi_P
do
sed -i s/$G/`echo $G |awk '{print $1+20}'`/g /ap/${TomcatWebName}/conf/server.xml
grep --color=always `echo $G |awk '{print $1+20}'` /ap/${TomcatWebName}/conf/server.xml
done
;;
*) echo "請輸入站台序號(0~2)" # 有 var2 判斷，這邊應該用不到XD
   echo -e "待確認後再執行，離開安裝程式! \n"
   exit 1 ;;
esac
	if [[ -L /log/${TomcatWebName}/logs ]] ; then #4 建log的soft link
        echo -en "==log link  已存在," ; sleep 1
        echo -e "故/ap/${TomcatWebName}/logs 維持不變== \n"
	  else #4
	    mkdir -p /log/${TomcatWebName}
	    ln -sf /log/${TomcatWebName} /ap/${TomcatWebName}/logs
	    chown -R proap:proap /log/${TomcatWebName}
	  fi #4	
		
	else #3 tomcat.tar.gz checksum
	  echo "驗證失敗，請洽系統人員!"
	  exit 1        
	fi #3
	
  else #2 test tomcat exist
  echo -e "tomcat目錄不存在，請洽系統人員! \n"
  exit 1
  fi #2
  
fi #1 check APName and AP_NO

if [ ! -f /ap/bin/start_tomcat.sh ] ;then # 若start_tomcat不存在就新增並修改
		mkdir -p /ap/bin
		CTS # Copy TomCat Shell function
		MTS # Modify TomCat Shell function
		chown -R proap:proap /ap/bin
	elif [ ! -f /ap/bin/start_${TomcatWebName}.sh ] ;then #若已存在就新增站台shell
		echo "start_tomcat.sh已存在，新增其他shell" ;sleep 2	
		cd $WRK_PATH
		cp showui.sh /ap/bin/
		chown proap:proap /ap/bin/showui.sh
		MTS # Modify TomCat Shell function
	else
		echo -e "已有重複站台名稱${TomcatWebName}，安裝中止！"
		exit 1
		fi

echo -e "==============  Install Success!  ===============\n"
exit 0

