#used specifically only with vrealize automation

#!/bin/bash
####Initial setup script to join Satellite + configure puppet###

###Find RHEL Major Version
rhelver=$(cat /etc/redhat-release | awk -F '[^0-9]*' '$0=$2')

echo ""
echo "Server OS is RHEL $rhelver"

###Register to Satellite and activate according to RHEL version
rpm -Uvh http://satellite.blah.com/pub/katello-ca-consumer-latest.noarch.rpm
subscription-manager register --org="blah" --activationkey="RHEL$rhelver"

###Install katello-agent and puppet
yum -y install katello-agent puppet

###Update System
yum update -y

###Add the necessary configs for Puppet
echo 'ca_server= satellite.blah.com' >> /etc/puppetlabs/puppet/puppet.conf
echo 'server= satellite.blah.com' >> /etc/puppetlabs/puppet/puppet.conf

###Start and enable Puppet
if [ "$rhelver" == "7" ]; then 
	systemctl enable puppet
	systemctl start puppet
elif [ "$rhelver" == "6" ]; then
    service start puppet
    chkconfig on puppet
fi

history -c

sleep 60