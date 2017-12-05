#!/bin/sh

compName=`/usr/sbin/networksetup -getcomputername`
/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Starting `/usr/bin/basename $0` >> /var/log/system.log
hour=`/bin/date "+%H"`
#echo $hour

if [ $hour -ge 0 ] && [ $hour -le 6 ]; then

	clientIdentifier=`/usr/bin/curl -k -s --user user:password https://deploystudio.server.com:60443/scripts/get/entry?id=ConfigMunkiClients.pl | /usr/bin/egrep -i $compName | /usr/bin/cut -d '"' -f 2 | /usr/bin/cut -d "," -f 1`
	/usr/bin/defaults write /Library/Preferences/ManagedInstalls ClientIdentifier $clientIdentifier
	
	server=`/usr/bin/defaults read /Library/Preferences/ManagedInstalls SoftwareRepoURL | /usr/bin/sed -e 's:/*::g' | /usr/bin/cut -d ":" -f 2`
	magicnum=$(($RANDOM%3600+1))
#	magicnum=2
	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: "Going to sleep for $magicnum seconds." >> /var/log/system.log

	/bin/sleep $magicnum

	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Done sleeping. >> /var/log/system.log

	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Testing Munki reachability... >> /var/log/system.log

	serverup=`/sbin/ping -t 5 -c 1 $server 2>&1 | /usr/bin/grep -c "round-trip"`
	if [ $serverup -eq 1 ]; then
	 	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Ping successful! >> /var/log/system.log
		SUCCESS="YES"
	else
		/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Ping failed... >> /var/log/system.log
		SUCCESS="NO"
	fi
  
	if [ $SUCCESS = "YES" ]; then
		/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: KickStarting Munki. >> /var/log/system.log
		/usr/bin/touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup
	fi

	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Ending `/usr/bin/basename $0` >> /var/log/system.log

else
	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Outside of the time of  12 AM to 6AM. >> /var/log/system.log
	/bin/echo `/bin/date "+%b %e %H:%M:%S"` $compName `/usr/bin/basename $0`[$$]: Ending `/usr/bin/basename $0` >> /var/log/system.log
fi

exit 0

