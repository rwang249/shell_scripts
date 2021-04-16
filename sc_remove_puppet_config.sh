#used specifically only with vrealize automation

#!/bin/bash

#Set Login Password to Satellite
otext=`echo 'xxxx' | base64 --decode`

#Get Hostname
hostname=`hostname`

#Get server ID
server_id=`curl --request GET --user $otext -s -k https://satellite.blah.com/api/hosts?search=$hostname | egrep -io '\"name\"\:.*\,\"id\"\:...,' | cut -d "," -f 2 | cut -d ":" -f 2`

#Unregister/Delete Subscription
curl -X DELETE -s -k -u $otext https://satellite.blah.com/api/v2/hosts/$server_id/subscriptions

#Completely remove host from Satellite
curl -X DELETE -s -k -u $otext https://satellite.blah.com/api/v2/hosts/$server_id