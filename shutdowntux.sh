#!/bin/bash

#script should be triggered by calling a system service on server startup/shutdown
#shutdown apps
#check status of apps and see if they are still up
#if apps are still running then wait 3 minutes
#if apps are down proceed to next step

date=$(date)

### Check status of Tuxedo ###
hr92uatapp_status=$(su - psadm1 -c "psadmin -c status -d HR92UAT | cut -f1 -d ' '")
hr92uatintapp_status=$(su - psadm1 -c "psadmin -c status -d HR92UATINT | cut -f1 -d ' '")
hr92uatps_status=$(su - psadm1 -c "psadmin -p status -d HR92UAT | cut -f1 -d ' '")


if [ $hr92uatapp_status == "Stopped" ];
then
        echo "$date tux_hr92uat is shutdown" >> /tmp/autodb_log.txt
fi

if [ $hr92uatintapp_status == "Stopped" ];
then
        echo "$date tux_hr92uatint is shutdown" >> /tmp/autodb_log.txt
fi

if [ $hr92uatps_status == "Stopped" ];
then
        echo "$date tux_hr92uat is shutdown" >> /tmp/autodb_log.txt
fi

### Check hr92uat ###
if [ $hr92uatapp_status == "Started" ];
then
        su - psadm1 -c 'psadmin -c shutdown! -d HR92UAT'
        while [ $hr92uatapp_status == "Started" ];
        do
                hr92uatapp_status=$(su - psadm1 -c "psadmin -c status -d HR92UAT | cut -f1 -d ' '")
                if [ $hr92uatapp_status == "Started" ];
                then
                        /bin/sleep 60
                else
                        date=$(date)
                        echo "$date tux_hr92uat is shutdown" >> /tmp/autodb_log.txt
                fi
        done
fi

### Check hr92uatint ###
if [ $hr92uatintapp_status == "Started" ];
then
        su - psadm1 -c 'psadmin -c shutdown! -d HR92UATINT'
        while [ $hr92uatintapp_status == "Started" ];
        do
                hr92uatintapp_status=$(su - psadm1 -c "psadmin -c status -d HR92UATINT | cut -f1 -d ' '")
                if [ $hr92uatintapp_status == "Started" ];
                then
                        /bin/sleep 60
                else
                        date=$(date)
                        echo "$date tux_hr92uatint is shutdown" >> /tmp/autodb_log.txt
                fi
        done
fi

### Check hr92uatps ###
if [ $hr92uatps_status == "Started" ];
then
        su - psadm1 -c 'psadmin -p kill -d HR92UAT'
        while [ $hr92uatps_status == "Started" ];
        do
                hr92uatps_status=$(su - psadm1 -c "psadmin -p status -d HR92UAT | cut -f1 -d ' '")
                if [ $hr92uatps_status == "Started" ];
                then
                        /bin/sleep 60
                else
                        date=$(date)
                        echo "$date tux_hr92uatps is shutdown" >> /tmp/autodb_log.txt
                fi
        done
fi

