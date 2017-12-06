#!/bin/sh

# SleepDisabled_installcheck.sh
# this will run as a Munki install_check script
# exit status of 0 means install needs to run
# exit status not 1 means no installation necessary

myOS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | /usr/bin/cut -d "." -f 2`

if [ $myOS -eq 12 ]; then
	/bin/echo "SleepDisabled: MacOS 10.12.x"
	exitCode=0
	SleepDisabled=`/usr/libexec/PlistBuddy -c "Print :SystemPowerSettings:SleepDisabled" /Library/Preferences/com.apple.PowerManagement.plist`
	if [ $SleepDisabled == "true" ]; then
		/bin/echo "SleepDisabled: Sleep is currently disabled."
		exitCode=1
	else
		exitCode=0
	fi
else
	/bin/echo "SleepDisabled: Mac OS X 10.x.x"
	exitCode=0
	exitCode=`/usr/bin/defaults read /Library/Preferences/SystemConfiguration/com.apple.PowerManagement SystemPowerSettings 2>/dev/null | /usr/bin/egrep -ic SleepDisabled`
fi

exit $exitCode