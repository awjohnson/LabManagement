#!/bin/sh

# EnableARD_installcheck.sh

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki export PATH

# this will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary

# adapted scripts from  here: https://jamfnation.jamfsoftware.com/discussion.html?id=1989

	# Checking to see if ARD is running.
ardrunning=$(ps ax | grep -c -i "[Aa]rdagent")

if [[ $ardrunning -eq 0 ]]; then
	/bin/echo "ARD is not running."
	exit 0
# else
# 	/bin/echo "ARD is running."
fi

	# Checking to see if All Users access is off.
all_users=$(defaults read /Library/Preferences/com.apple.RemoteManagement ARD_AllLocalUsers 2>/dev/null)

if [[ $all_users -eq 1 ]]; then
	/bin/echo "All Users Access is enabled."
	exit 0
# else
# 	/bin/echo "All Users Access is not enabled."
fi

	# Checking to see if the admin account is privileged.
ard_admins=$(/usr/bin/dscl . list /Users naprivs | cut -d ' ' -f 1)

if [[ $ard_admins != *admin* ]]; then
	/bin/echo "Admin account is not listed as an ARD administrator."
	exit 0
# else
# 	/bin/echo "Admin account is listed as an ARD administrator."
fi

	# Checking to see if Directory Group Logins is enabled.
dir_logins=$(/usr/bin/defaults read /Library/Preferences/com.apple.RemoteManagement DirectoryGroupLoginsEnabled 2>/dev/null)

if [[ $dir_logins -ne 1 ]]; then
	/bin/echo "DirectoryGroupLoginsEnabled is not enabled."
	exit 0
# else
# 	/bin/echo "DirectoryGroupLoginsEnabled is enabled."
fi

	# Checking to see if ard_admin group exists.
group=$(/usr/bin/dscl . list /Groups | /usr/bin/egrep -ic ard_admin);
if [[ $group -ne 1 ]]; then
	/bin/echo "ard_admin group does not exist."
	exit 0
# else
# 	/bin/echo "ard_admin group exists."
fi

	# Checking to see if the AD "TLT ARD admins" group is nested in the ard_admin local group.
isNested=$(/usr/bin/dscl . read /Groups/ard_admin NestedGroups | /usr/bin/cut -d " " -f 2 | /usr/bin/grep -ic 1AFA17DF-C645-4CAF-847A-3770B4981F6B);
if [[ $isNested -ne 1 ]]; then
	/bin/echo "\"TLT ARD admins\" group is not nested in ard_admin local group."
	exit 0
# else
# 	/bin/echo "\"TLT ARD admins\" group is nested in ard_admin local group."
fi

/bin/echo "EnableARD: Everything looks great."

exit 1

