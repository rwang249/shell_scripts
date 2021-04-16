#!/bin/bash

#script should be triggered by calling a system service on server startup/shutdown
#opa auto start script

##############################################################################
#######################          OPA           ###############################
##############################################################################
#start apps
#check status of apps and see if they are still down
#if apps are not running then wait for 3 min
#if apps are up proceed to next step

date=$(date)

### Set flags for environments ###
ss -atnp | grep 7005 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 1 ];
then
        prodqafinish="true"
else
        prodqafinish="false"
        echo "$date prodqa is running" >> /tmp/autoopa_log.txt
fi

ss -atnp | grep 7007 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 1 ];
then
        uat2finish="true"
else
        uat2finish="false"
        echo "$date uat2 is running" >> /tmp/autoopa_log.txt
fi


ss -atnp | grep 7006 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
if [ $? -eq 1 ];
then
        uatfinish="true"
else
        uatfinish="false"
        echo "$date uat is running" >> /tmp/autoopa_log.txt
fi

### Check prodqa ###

if [ $prodqafinish == "true" ];
then
        su - OPAADM02 -c 'nohup /u01/app/oracle/Middleware/user_projects/domains/opaprdqa1/bin/startWebLogic.sh < /dev/null &> /dev/null &'

        while [ $prodqafinish == "true" ];
        do
                ss -atnp | grep 7005 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
                if [ $? -eq 1 ];
                then
                        /bin/sleep 60
                else
                        prodqafinish="false"
                        date=$(date)
                        echo "$date prodqa is running" >> /tmp/autoopa_log.txt
                fi
        done
fi

### Check uat2 ###

if [ $uat2finish == "true" ];
then
        su - OPAUAT2 -c 'nohup /u01/app/oracle/Middleware/user_projects/domains/opauat2/bin/startWebLogic.sh < /dev/null &> /dev/null &'

        while [ $uat2finish == "true" ];
        do
                ss -atnp | grep 7007 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
                if [ $? -eq 1 ];
                then
                        /bin/sleep 60
                else
                        uat2finish="false"
                        date=$(date)
                        echo "$date uat2 is running" >> /tmp/autoopa_log.txt
                fi
        done
fi

### Check uat ###

if [ $uatfinish == "true" ];
then
        su - OPAUAT -c 'nohup /u01/app/oracle/Middleware/user_projects/domains/opauat1/bin/startWebLogic.sh < /dev/null &> /dev/null &'

        while [ $uatfinish == "true" ];
        do
                ss -atnp | grep 7006 | grep -v 'TIME-WAIT' | grep -v 'CLOSED'
                if [ $? -eq 1 ];
                then
                        /bin/sleep 60
                else
                        uatfinish="false"
                        date=$(date)
                        echo "$date uat is running" >> /tmp/autoopa_log.txt
                fi
        done
fi




