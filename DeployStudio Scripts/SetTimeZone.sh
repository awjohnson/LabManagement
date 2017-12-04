#!/bin/sh

# start here

/usr/sbin/systemsetup -setusingnetworktime on
/usr/sbin/systemsetup -setnetworktimeserver "time.stonybrook.edu"
/usr/sbin/systemsetup -settimezone "America/New_York"

networkserver=`/usr/sbin/systemsetup -getnetworktimeserver | /usr/bin/cut -d ":" -f 2 | /usr/bin/sed s'/ //'`
if [ $networkserver != "time.stonybrook.edu" ]; then
	/usr/sbin/systemsetup -setnetworktimeserver "time.stonybrook.edu"
fi

/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

/usr/bin/defaults write /private/var/.home/rtadmin/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
/usr/bin/defaults write /private/var/.home/rtadmin/Library/Preferences/com.apple.SetupAssistant DidSeeiCloudSecuritySetup -bool TRUE
/usr/bin/defaults write /private/var/.home/rtadmin/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion 10.11.4

/bin/mv /System/Library/CoreServices/Setup\ Assistant.app/Contents/SharedSupport/MiniLauncher /System/Library/CoreServices/Setup\ Assistant.app/Contents/SharedSupport/MiniLauncher.backup

/usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false


exit 0

