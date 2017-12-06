#!/bin/sh

# enableSSH_uninstall.sh

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki export PATH

# Disable ssh
if [[ $(systemsetup -getremotelogin) = 'Remote Login: On' ]]; then
    echo "EnableSSH: turning off Remote Login/SSH"
    systemsetup -f -setremotelogin off
fi

exit 0</string>
