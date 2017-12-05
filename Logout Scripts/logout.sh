#!/bin/sh

#/bin/echo `date` " Starting $0"  > /Users/admin/Library/Logs/logout.sh.log

onLogout() {
#    /bin/echo `date` " Logging out" >> /Users/admin/Library/Logs/logout.sh.log
#    /bin/echo `who | egrep -i console | awk -F " " '{print $1}'`  >> /Users/admin/Library/Logs/logout.sh.log
#    /bin/echo `defaults read /Library/Preferences/com.apple.loginwindow lastUserName` >> /Users/admin/Library/Logs/logout.sh.log
	/usr/bin/touch /Users/Shared/logoff/logoff
	exit 0
}

trap 'onLogout' SIGINT SIGHUP SIGTERM SIGQUIT SIGABRT
sleep 86400 &
while wait $!
do sleep 86400 &
done

