#!/bin/bash

# addAdmins_postinstall.sh
exists=`/usr/bin/dscl . read /Groups/admin GroupMembership| /usr/bin/egrep -ic AD_ID1`

if [ $exists -eq 1 ]; then
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID1 is already in the local admin group."
else
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID1 is not in the local admin group. Will try to add it now."
	/usr/bin/dscl . -append /Groups/admin GroupMembership DOMAIN\\\!AD_ID1
fi

exists=`/usr/bin/dscl . read /Groups/admin GroupMembership| /usr/bin/egrep -ic AD_ID2`

if [ $exists -eq 1 ]; then
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID2 is already in the local admin group."
else
	/bin/echo "addAdmins: User DOMAIN\\!AD_ID2 is not in the local admin group. Will try to add it now."
	/usr/bin/dscl . -append /Groups/admin GroupMembership DOMAIN\\\!AD_ID2
fi

exit 0
