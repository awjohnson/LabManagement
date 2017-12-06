#!/bin/sh

# UnlockPrinters_installcheck.sh
# this will run as a Munki install_check script
# exit status of 0 means install needs to run
# exit status NOT 0 means no installation necessary

/usr/bin/security authorizationdb read system.print.operator 2>/dev/null > /private/tmp/preSPO.plist

myGroup=`/usr/bin/defaults read /private/tmp/preSPO.plist group`
exitStatus=0


if [ $myGroup == "_lpoperator" ]; then
	/bin/echo "UnlockPrinters: Users can't un-pause print queues."
	exitStatus=0
elif [ $myGroup == "everyone" ]; then
	/bin/echo "UnlockPrinters: Users can un-pause print queues."
	/bin/rm -Rf /private/tmp/preSPO.plist
	exitStatus=1
fi

exit $exitStatus

