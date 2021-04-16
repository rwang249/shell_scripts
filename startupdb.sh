#!/bin/bash

#script should be triggered by calling a system service on server startup/shutdown
#oracle auto start script

##############################################################################
#######################       Peoplesoft       ###############################
##############################################################################

#start apps
#check status of apps and see if they are still down
#if apps are not running then wait for 3 min
#if apps are up proceed to next step

date=$(date)

### Set flags for databases ###
su - psadm1 -c "ps -ef | grep hr92uat | grep -v 'grep hr92uat' | grep -v 'hr92uatint'"
if [ $? -eq 1 ];
then
        hr92uatfinish="true"
else
        hr92uatfinish="false"
        echo "$date hr92uat is running" >> /tmp/autodb_log.txt
fi

su - psadm1 -c "ps -ef | grep hr92uatint | grep -v 'grep hr92uatint'"
if [ $? -eq 1 ];
then
        hr92uatintfinish="true"
else
        hr92uatintfinish="false"
        echo "$date hr92uatint is running" >> /tmp/autodb_log.txt
fi

### Check hr92uat ###

if [ $hr92uatfinish == "true" ];
then
        su - psadm1 -c 'psadmin -w start -d hr92uat'
        while [ $hr92uatfinish == "true" ];
        do
                ps -ef | grep hr92uat | grep -v 'grep hr92uat' | grep -v 'hr92uatint'
                if [ $? -eq 1 ];
                then
                        /bin/sleep 60
                else
                        hr92uatfinish="false"
                        date=$(date)
                        echo "$date hr92uat is running" >> /tmp/autodb_log.txt
                fi
        done
fi

### Check hr92uatint ###
if [ $hr92uatintfinish == "true" ];
then
        su - psadm1 -c 'psadmin -w start -d hr92uatint'
        while [ $hr92uatintfinish == "true" ];
        do
                ps -ef | grep hr92uatint | grep -v 'grep hr92uatint'
                if [ $? -eq 1 ];
                then
                        /bin/sleep 60
                else
                        hr92uatintfinish="false"
                        date=$(date)
                        echo "$date hr92uatint is running" >> /tmp/autodb_log.txt
                fi
        done
fi

##############################################################################
#########################           OAM          #############################
##############################################################################
### switch to oamadmin and shutdown local services ###

#check for status of oam
su - oamadmin -c "/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl status | grep Alive"
if [ $? -eq 1 ];
then
        oamfinish="true"
else
        oamfinish="false"
        echo "$date OAM is running" >> /tmp/autodb_log.txt
fi

if [ $oamfinish == "true" ];
then
        su - oamadmin -c '/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl startall'
                while [ $oamfinish == "true" ];
                do
                        su - oamadmin -c "/u01/ohs/Middleware/Oracle_WT1/instances/instance1/bin/opmnctl status" | grep Alive
                        if [ $? -eq 1 ];
                        then
                                /bin/sleep 60
                        else
                                oamfinish="false"
                                date=$(date)
                                echo "$date OAM is running" >> /tmp/autodb_log.txt
                        fi
        done
fi




