#!/bin/bash

#script should be triggered by calling a system service on server startup/shutdown
#opa auto shutdown/start script

##############################################################################
#######################           OPA          ###############################
##############################################################################

#shutdown apps
#check status of apps and see if they are still up
#if apps are still running then wait 3 minutes
#if apps are down proceed to next step

date=$(date)

### Set flags for databases ###
ss -atnp | grep 7005 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 0 ];
then 
	prodqafinish="false"
else
	prodqafinish="true"
	echo "$date prodqa is shutdown" >> /tmp/autoopa_log.txt
fi

ss -atnp | grep 7007 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 0 ];
then 
	uat2finish="false"
else
	uat2finish="true"
	echo "$date uat2 is shutdown" >> /tmp/autoopa_log.txt
fi

ss -atnp | grep 7006 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 0 ];
then 
	uatfinish="false"
else
	uatfinish="true"
	echo "$date uat is shutdown" >> /tmp/autoopa_log.txt
fi



### Check prodqa ###

if [ $prodqafinish == "false" ];
then
	su - OPAADM02 -c '/u01/app/oracle/Middleware/user_projects/domains/opaprdqa1/bin/stopWebLogic.sh'
	while [ $prodqafinish == "false" ];
	do
		ss -atnp | grep 7005 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
		if [ $? -eq 0 ];
		then
			/bin/sleep 60
		else
			prodqafinish="true"
			date=$(date)
			echo "$date prodqa is shutdown" >> /tmp/autoopa_log.txt
		fi
	done
fi

### Check uat2 ###
if [ $uat2finish == "false" ];
then
	su - OPAUAT2 -c '/u01/app/oracle/Middleware/user_projects/domains/opauat2/bin/stopWebLogic.sh'
	while [ $uat2finish == "false" ];
	do
		ss -atnp | grep 7007 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
		if [ $? -eq 0 ];
		then
			/bin/sleep 60
		else
			uat2finish="true"
			date=$(date)
			echo "$date uat2 is shutdown" >> /tmp/autoopa_log.txt
		fi
	done
fi

### Check uat ###
if [ $uatfinish == "false" ];
then
	su - OPAUAT -c '/u01/app/oracle/Middleware/user_projects/domains/opauat1/bin/stopWebLogic.sh'
	while [ $uatfinish == "false" ];
	do
		ss -atnp | grep 7006 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
		if [ $? -eq 0 ];
		then
			/bin/sleep 60
		else
			uatfinish="true"
			date=$(date)
			echo "$date uat is shutdown" >> /tmp/autoopa_log.txt
		fi
	done
fi