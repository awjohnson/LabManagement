#!/bin/sh

# EnableFileSharing_installcheck.sh
# this will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary

exitStatus=1

isRunning=`/bin/launchctl list | /usr/bin/egrep -ic com.apple.AppleFileServer`

if [ $isRunning -eq 0 ]; then
	/bin/echo "EnableFileSharing: Apple File Sharing is off..."
	exitStatus=0
elif [ $isRunning -gt 0 ]; then
	/bin/echo "EnableFileSharing: Apple File Sharing is on..."
fi

exit $exitStatus

