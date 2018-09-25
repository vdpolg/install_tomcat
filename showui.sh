#!/bin/bash

typeset -i jpd_coun=`ps -ef | grep AP-NAME | grep java | grep -v grep | wc -l`
if [[ $jpd_coun == "0" ]] ; then
	  printf "\E[0;31;40m"   #red
	    echo "AP-NAME is Not Running"
		else
			  printf "\E[0;32;40m"   #green
			    echo "AP-NAME is Running"
				fi
				printf "\E[0m"   #white
				exit 0

