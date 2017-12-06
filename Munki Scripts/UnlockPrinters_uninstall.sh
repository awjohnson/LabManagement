#!/bin/sh

# UnlockPrinters_uninstall.sh
	# Get the existing settings in the system.print.operator database, and dump them to a plist.
/usr/bin/security authorizationdb read system.print.operator 2>/dev/null > /private/tmp/spo.plist

	# Re write the changed variable back to the plist file 
/usr/bin/defaults write /private/tmp/spo group -string "_lpoperator"
	
	# Dump the plist file back into the system.print.operator database.
/usr/bin/security authorizationdb write system.print.operator < /private/tmp/spo.plist 2>/dev/null

	# Remove the temporary plist file.
/bin/rm -Rf /private/tmp/spo.plist

exit 0
