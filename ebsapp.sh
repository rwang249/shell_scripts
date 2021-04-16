#!/bin/bash
#UPSIT Startup Script


date=$(date)

ebsinfo=$(/root/scripts/ebsinfo.sh)
ebsweb=$(/root/scripts/ebsweb.sh)

su - appupsit -c ". /u01/EBS122/UPSIT/EBSapps.env run"
su - appupsit -c "cd $ADMIN_SCRIPTS_HOME & adstrtal.sh $ebsinfo <<EOF
$ebsweb
EOF"
sleep 30

ps -ef|grep appupsit|grep -v grep |grep -v bash|grep -v sshd |grep -v 'ps -ef'| grep -v startupapps | grep -v 'su - appupsit'
if [ $? -eq 0 ];
then
	echo "$date EBSapps are running" >> /tmp/autoebs_log.txt
fi

#!/bin/bash
#UPSIT Shutdown Script

date=$(date)

ebsinfo=$(/root/scripts/ebsinfo.sh)
ebsweb=$(/root/scripts/ebsweb.sh)

su - appupsit -c ". /u01/EBS122/UPSIT/EBSapps.env run"
su - appupsit -c "cd $ADMIN_SCRIPTS_HOME & adstpall.sh $ebsinfo <<EOF
$ebsweb
EOF"
sleep 20

ps -ef|grep appupsit|grep -v grep |grep -v bash|grep -v sshd |grep -v 'ps -ef'| grep -v shutdownapps | grep -v 'su - appupsit'| awk '{print $2}'| xargs --no-run-if-empty kill -9
sleep 15
ps -ef|grep appupsit|grep -v grep |grep -v bash|grep -v sshd |grep -v 'ps -ef'| grep -v shutdownapps | grep -v 'su - appupsit'
if [ $? -eq 1 ];
then
	echo "$date EBSapps are shutdown" >> /tmp/autoebs_log.txt
fi