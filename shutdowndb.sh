#!/bin/bash

#script should be triggered by calling a system service on server startup/shutdown
#oracle auto shutdown/start script

##############################################################################
#######################       Peoplesoft       ###############################
##############################################################################

#shutdown apps
#check status of apps and see if they are still up
#if apps are still running then wait 3 minutes
#if apps are down proceed to next step

date=$(date)

### Set flags for databases ###
su - psadm1 -c "ps -ef | grep hr92uat | grep -v 'grep hr92uat' | grep -v 'hr92uatint'"
if [ $? -eq 0 ];
then 
	hr92uatfinish="false"
else
	hr92uatfinish="true"
	echo "$date hr92uat is shutdown" >> /tmp/autodb_log.txt
fi

su - psadm1 -c "ps -ef | grep hr92uatint | grep -v 'grep hr92uatint'"
if [ $? -eq 0 ];
then 
	hr92uatintfinish="false"
else
	hr92uatintfinish="true"
	echo "$date hr92uatint is shutdown" >> /tmp/autodb_log.txt
fi

### Check hr92uat ###

if [ $hr92uatfinish == "false" ];
then
	su - psadm1 -c 'psadmin -w shutdown! -d hruat'
	while [ $hr92uatfinish == "false" ];
	do
		ps -ef | grep hr92uat | grep -v 'grep hr92uat' | grep -v 'hr92uatint'
		if [ $? -eq 0 ];
		then
			/bin/sleep 60
		else
			hr92uatfinish="true"
			date=$(date)
			echo "$date hr92uat is shutdown" >> /tmp/autodb_log.txt
		fi
	done
fi

### Check hr92uatint ###
if [ $hr92uatintfinish == "false" ];
then
	su - psadm1 -c 'psadmin -w shutdown! -d hr92uatint'
	while [ $hr92uatintfinish == "false" ];
	do
		ps -ef | grep hr92uatint | grep -v 'grep hr92uatint'
		if [ $? -eq 0 ];
		then
			/bin/sleep 60
		else
			hr92uatintfinish="true"
			date=$(date)
			echo "$date hr92uatint is shutdown" >> /tmp/autodb_log.txt
		fi
	done
fi

##############################################################################
#########################   	    OAM          #############################
##############################################################################
### switch to oamadmin and shutdown local services ###

#check for status of oam
su - oamadmin -c "/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl status | grep Alive"
if [ $? -eq 0 ];
then
	oamfinish="false"
else
	oamfinish="true"
	echo "$date OAM is shutdown" >> /tmp/autodb_log.txt
fi

if [ $oamfinish == "false" ];
then
	su - oamadmin -c '/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl stopall'
		while [ $oamfinish == "false" ];
		do
			su - oamadmin -c "/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl status" | grep Alive
			if [ $? -eq 0 ];
			then
				/bin/sleep 60
			else
				oamfinish="true"
				date=$(date)
				echo "$date OAM is shutdown" >> /tmp/autodb_log.txt
			fi
	done
fi
