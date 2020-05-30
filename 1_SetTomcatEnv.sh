#!/bin/bash
# 名稱          版本    日期            作者            備註
# SetTomcatEnv  v0.1    20200530        arthur_lai      初版

echo 'create tomcat group GID=220 '
groupadd -g 220 tomcat

echo -n 'create ap user, input name : '; read APNAME
echo -n 'input uid : ' ; read Uid

useradd -u $Uid $APNAME -g tomcat

echo -e "\n==     Account Data           =="
id $APNAME

echo -e "\n== List Tomcat Group Account: =="

grep 220 /etc/passwd

# create folder
mkdir -p /ap/bin
echo -n 'input Tomcat Web Name : ' ; read TomcatWebName
mkdir -p /ap/$TomcatWebName
# create Log folder
mkdir -p /log/$TomcatWebName
chown $APNAME:tomcat /log/$TomcatWebName
ln -s /log/$TomcatWebName /ap/$TomcatWebName/logs
chown -h $APNAME:tomcat /ap/$TomcatWebName/logs
if [ $? != 0 ] ; then
echo 'please try again !!'
exit 1
fi
echo -e "\n== List Tomcat Group Account: =="
echo -e "\n==         success            ==\n"

echo APNAME=$APNAME > .TomcatEnv.tmp
echo TomcatWebName=$TomcatWebName >> .TomcatEnv.tmp
exit 0

