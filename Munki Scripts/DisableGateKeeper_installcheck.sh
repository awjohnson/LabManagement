#!/bin/bash

# DisableGateKeeper_installcheck.sh
# this will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary

exitStat=1

secStat=`/usr/sbin/spctl --status | /usr/bin/egrep -ic enabled`

if [ $secStat -eq 1 ]; then
	/bin/echo "DisableGateKeeper: GateKeeper is on."
	exitStat=0
else
	/bin/echo "DisableGateKeeper: GateKeeper is off."
fi

exit $exitStat
