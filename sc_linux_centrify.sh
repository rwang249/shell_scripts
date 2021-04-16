#used specifically only with vrealize automation

#!/bin/bash
###Script to install Centrify###

###Install Centrify Agent###
/root/agents/centrify_5.5.2/install.sh --std-suite --suite-config /root/agents/centrify_5.5.2/centrify-suite.cfg

###Join Server to Domain###
/usr/sbin/adjoin -S blah.com