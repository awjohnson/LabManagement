#!/bin/bash

# Written by: Andrew W. Johnson
# 2016.11.07
# Version: 1.00
#
# This script will grab who logs off the workstation and post it to a web server
# along with the computer name for statistical usage purposes.
# 

	# Version number.
vers="1.00"
	# Get the name of the this script.
myName=`/usr/bin/basename $0`
	# Get the processe ID for this script.
myPID=$$
	 # Create the path to the log name and location.
logName="/private/tmp/`/usr/bin/basename $0 | /usr/bin/cut -d "." -f 1`.log"
	# Get the computer name.
CompName=`/usr/sbin/networksetup -getcomputername`

	# Get current timestamp in log format.
myDate=`/bin/date +"%b %d %H:%M:%S"`
/bin/echo $myDate $myName[$myPID]: Starting $myName v$vers. >> $logName

	# Get the users logging in on the console.
user=`/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
	# If no user is returned, sleep until a user is returned. This is in case it
	# takes a few seconds from when the script fires off and a user is recorded
	# as a console user.
if [ -z $user  ]; then
	myDate=`/bin/date +"%b %d %H:%M:%S"`
	/bin/echo $myDate $myName[$myPID]: No user specified. >> $logName
	myDate=`/bin/date +"%b %d %H:%M:%S"`
	/bin/echo $myDate $myName[$myPID]: Ending $myName v$vers. >> $logName
	exit 1
fi

myDate=`/bin/date +"%b %d %H:%M:%S"`
/bin/echo $myDate $myName[$myPID]: $user >> $logName

	# Curl the data up to the web site.
result=`/usr/bin/curl -s -X POST -F Username=$user -F ComputerName=$CompName https://stats.sinc.stonybrook.edu/api/logoff/update`

myDate=`/bin/date +"%b %d %H:%M:%S"`
/bin/echo $myDate $myName[$myPID]: $result >> $logName

myDate=`/bin/date +"%b %d %H:%M:%S"`
/bin/echo $myDate $myName[$myPID]: Ending $myName v$vers. >> $logName

exit 0



