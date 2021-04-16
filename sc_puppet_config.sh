#used specifically only with vrealize automation

#!/bin/bash
#Puppet Env Selection

env="$env"
serverteam="$team"

#Set Login Password to Satellite
otext=`echo 'xxxx' | base64 --decode`

#Get Hostname
hostname=`hostname`

#Get server ID
server_id=`curl --request GET --user $otext -s -k https://satellite.blah.com/api/hosts?search=$hostname | egrep -io '\"name\"\:.*\,\"id\"\:...,' | cut -d "," -f 2 | cut -d ":" -f 2`

    if [ "$env" == "DEV" ] && [ "$serverteam" == "Server Team" ]; then
        #DEV
		curl -H "Accept:application/json,version=2" -H "Content-Type:application/json" -X PUT -u $otext -k -d "{\"host\":{\"hostgroup_id\":\"1\"}}" https://satellite.blah.com/api/hosts/$server_id
    else
    	exit 1;
    fi
