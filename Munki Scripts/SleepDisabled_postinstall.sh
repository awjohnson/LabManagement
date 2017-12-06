#!/bin/sh

# SleepDisabled_postinstall.sh

myOS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | /usr/bin/cut -d "." -f 2`

if [ $myOS -eq 12 ]; then
	/bin/echo "SleepDisabled: Disabling sleep."
	/usr/bin/defaults write /Library/Preferences/com.apple.PowerManagement SystemPowerSettings -dict SleepDisabled -bool YES
else
	/bin/echo "SleepDisabled: Disabling sleep."
	/usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.PowerManagement SystemPowerSettings -dict SleepDisabled -bool YES
fi

exit 0
