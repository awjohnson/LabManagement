#!/bin/bash


PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki export PATH

# use kickstart to enable full Remote Desktop access
# for more info, see: http://support.apple.com/kb/HT2370

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"

	# Enable ARD access for local admin.
$kickstart -configure -access -on -users admin -privs -all

	# If local ard_admin group doesn't exist...
exists=`/usr/bin/dscl . list /Groups | /usr/bin/egrep -ic ard_admin`

	# Create a local ard_admin group using dscl
if [ $exists -eq 0 ]; then
	/bin/echo "Local ard_admin group doesn't exist. Will attempt to create it now."
	/usr/bin/dscl . -create /Groups/ard_admin
	/usr/bin/dscl . -create /Groups/ard_admin PrimaryGroupID "530"
	/usr/bin/dscl . -create /Groups/ard_admin Password "*"
	/usr/bin/dscl . -create /Groups/ard_admin RealName "ard_admin"
	/usr/bin/dscl . -create /Groups/ard_admin GroupMembers ""
	/usr/bin/dscl . -create /Groups/ard_admin GroupMembership ""
	
		# Add the AD "SUNYSB.EDU\TLT ARD Admins" to the ard_admin group.
	/usr/sbin/dseditgroup -o edit -a "SUNYSB.EDU\TLT ARD Admins" -t group ard_admin
else
	/bin/echo "Local ard_admin group already exists."
fi

	# Check to see if AD "SUNYSB.EDU\TLT ARD Admins" group is nested in the local ard_admin group. If not add it.
isNested=$(/usr/bin/dscl . read /Groups/ard_admin NestedGroups | /usr/bin/cut -d " " -f 2 | /usr/bin/grep -ic 1AFA17DF-C645-4CAF-847A-3770B4981F6B);
if [[ $isNested -ne 1 ]]; then
	/bin/echo "\"TLT ARD admins\" group is not nested in ard_admin local group. Attempting to add it now."
	/usr/sbin/dseditgroup -o edit -a "SUNYSB.EDU\TLT ARD Admins" -t group ard_admin
else
	/bin/echo "\"TLT ARD admins\" group is nested in ard_admin local group."
fi

	# Enable ARD access for the local ard_admin group. 
$kickstart -configure -access -on -privs -all -users ard_admin -restart -agent
	# Enable access for only specified users.
$kickstart -configure -allowAccessFor -specifiedUsers
	# Enable directory logins.
$kickstart -configure -clientopts -setdirlogins -dirlogins yes

	# Start it all up.
$kickstart -activate

exit 0
