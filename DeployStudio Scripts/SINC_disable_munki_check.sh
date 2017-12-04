#!/bin/sh

/bin/launchctl unload /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist
/bin/rm -Rf /Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist

exit 0

