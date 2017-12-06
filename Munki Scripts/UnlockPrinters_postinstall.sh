#!/bin/sh

# UnlockPrinters_postinstall.sh

	# Get the existing settings in the system.print.operator database, and dump them to a plist.
/usr/bin/security authorizationdb read system.print.operator 2>/dev/null > /private/tmp/spo.plist

	# Re write the changed variable back to the plist file 
/usr/bin/defaults write /private/tmp/spo group -string "everyone"
	
	# Dump the plist file back into the system.print.operator database.
/usr/bin/security authorizationdb write system.print.operator 2>/dev/null < /private/tmp/spo.plist

	# Remove the temporary plist file.
/bin/rm -Rf /private/tmp/spo.plist

exit 0


