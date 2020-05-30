#!/bin/bash
echo -e "\n======  show firewall setting  ======\n"
firewall-cmd --list-all
sleep 3
echo -e "\n======  default port=8080/tcp  ======\n"
firewall-cmd --add-port=8080/tcp --permanent
sleep 3
echo -e "\n======  reload and atcive  ======\n"
firewall-cmd --reload
firewall-cmd --list-all |grep 8080
echo -e "\n======  success  ======\n"
exit 0
