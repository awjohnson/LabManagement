#!/bin/bash

# UnlockScreenSaver_postinstall.sh
# Set up some variables: Location of file to be modded. Location of the 
# backupfile, and location of the temporary file.

oldFile="/private/etc/pam.d/screensaver"
bakFile="/private/etc/pam.d/screensaver.bak"
tmpFile="/private/tmp/screensaver"

	# If the backupfile doesn't exist, most likely the change hasn't been made.
	# So backup the file just in case.
if [ -e "$oldFile" ] && [ ! -e $bakFile ]; then
	/bin/cp $oldFile $bakFile
fi

	# The change is made by commenting out the last line which reads:
	# account    required       pam_group.so no_warn deny group=admin,wheel ruser fail_safe
	# Make the change with Sed. Basically add a # in front of the last line.
	# Pipe the command to the temporary file.
/bin/cat $oldFile | /usr/bin/sed -e "s/account    required       pam_group.so no_warn deny group=admin,wheel ruser fail_safe/# account    required       pam_group.so no_warn deny group=admin,wheel ruser fail_safe/" > $tmpFile
	# Copy the temporary file to replace the non modified file.
/bin/cp $tmpFile $oldFile
	# Properly adjust ownership and permissions on the file, just in case.
/bin/chmod 644 $oldFile
/usr/sbin/chown root:wheel $oldFile
	# Cleanup: Remove the temporary file.
/bin/rm $tmpFile

exit 0