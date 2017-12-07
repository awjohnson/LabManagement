#!/bin/bash

# addAdmins_installcheck.sh
# This will run as a munki install_check script.
# Exit status of 0 means install needs to run.
# Exit status not 0 means no installation is necessary.

exitStatus=1

exists=`/usr/bin/dscl . read /Groups/admin GroupMembership| /usr/bin/egrep -ic AD_ID1`

if [ $exists -eq 1 ]; then
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID1 is in the local admin group."
else
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID1 is not in the local admin group."
	exitStatus=0
fi

exists=`/usr/bin/dscl . read /Groups/admin GroupMembership| /usr/bin/egrep -ic AD_ID2`

if [ $exists -eq 1 ]; then
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID2 is in the local admin group."
else
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID2 is not in the local admin group."
	exitStatus=0
fi

exit $exitStatus

