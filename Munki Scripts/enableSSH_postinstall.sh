#!/bin/sh

# enableSSH_postinstall.sh

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki export PATH

ssh_group="com.apple.access_ssh"

# enable ssh
if [[ $(systemsetup -getremotelogin) = 'Remote Login: Off' ]]; then
    echo "EnableSSH: turning on Remote Login/SSH."
    systemsetup -setremotelogin On
fi

# Does a group named "com.apple.access_ssh" exist?
if [[ $(dscl /Local/Default list /Groups | grep "${ssh_group}-disabled" | wc -l) -eq 1 ]]; then
    #rename this group
    echo "EnableSSH: renaming group '${ssh_group}-disabled'."
    dscl localhost change /Local/Default/Groups/${ssh_group}-disabled RecordName ${ssh_group}-disabled $ssh_group
elif [[ $(dscl /Local/Default list /Groups | grep "$ssh_group" | wc -l) -eq 0 ]]; then
    # create group
    echo "EnableSSH: creating group $ssh_group."
    dseditgroup -o create -n "/Local/Default" -r "Remote Login Group" -T group $ssh_group
fi

# does the group contain the admin group?
admin_uuid=$(dsmemberutil getuuid -G admin)
if [[ $(dscl /Local/Default read Groups/$ssh_group NestedGroups | grep "$admin_uuid" | wc -l) -eq 0 ]]; then
    echo "EnableSSH: adding admin group to $ssh_group"
    dseditgroup -o edit -n "/Local/Default" -a admin -t group $ssh_group
fi

exit 0

