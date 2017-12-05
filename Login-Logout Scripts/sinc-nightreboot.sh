#!/bin/bash

myVer=2.02

/usr/bin/logger "Starting `/usr/bin/basename $0` $myVer."

	# Ensure root is running this program.
me=`/usr/bin/whoami`
if [ $me != "root" ]; then
	/usr/bin/logger "You must be root to run this script."
	exit 1
fi

# compName=`/usr/sbin/networksetup getcomputername | cut -c 1-3`
# 
# if [ $compName == "lim" ] || [ $compName == "lcm" ] || [ $compName == "lpm" ]; then
# 	exit 0
# fi


	# Set some variables.
BHT="/usr/local/bin/BigHonkingText" # Path to BigHonkingText

	# Check to see if BigHonkingText is installed in /usr/local/bin. If not, try to locate it.
if [ ! -e $BHT ]; then
	/usr/bin/logger "I'm sorry Dave, I can't find BigHonkingText in /usr/local/bin/"
	/usr/bin/logger "Dave, I will now try to locate it..."
	BHT=`/usr/bin/find / -name "BigHonkingText" 2>/dev/null`
	if [ -z $BHT ]; then
		/usr/bin/logger "I'm sorry Dave, I can't locate BigHonkingText."
		/usr/bin/logger "Ending `/usr/bin/basename $0` $myVer."
		exit 1;
	else
		/usr/bin/logger "Dave, I found BigHonkingText in `/usr/bin/dirname $BHT`."
		/usr/bin/logger "Dave, I will now continue."
	fi
fi
	# Initiate shutdown sequence.
/sbin/shutdown -r +11 &

	# Since shutdown is only as fine grained as per minute, and no seconds, I sleep 
	# for 40 seconds after the shutdown command has been initiated to shorten the time 
	# from the last warning to actual shutdown.
/usr/bin/logger "Sleeping for 40 seconds."
sleep 40

	# Setup variables for each warning sequence at 10, 5, and 0 minutes.
for i in 1 2 3
do
	if [ $i -eq 1 ]; then
		mySleep=300
		myTime=10
		myDuration=60
		myText="This computer will reboot in $myTime minutes. Please save your work."
	elif [ $i -eq 2 ]; then
		mySleep=300
		myTime=5
		myDuration=60
		myText="This computer will reboot in $myTime minutes. Please save your work."
	else
		mySleep=10
		myTime=0
		myDuration=0
		myText="This computer will reboot now."
	fi

		# Check to see if anyone is logged. If no one is logged in then don't bother 
		# displaying the user reboot warning. 
	myUser=`/usr/bin/who | /usr/bin/egrep -ic console`
	if  [ $myUser -eq 1 ]; then
			# write the user reboot warning to the system log.
		/usr/bin/logger $myText
			# Display user reboot warning with BigHonkingText.
		$BHT -f "ff0000" -b "663333" -X -p $myDuration -o 0.75 $myText &
	else
		/usr/bin/logger "I'm sorry Dave, there are no users logged in. No need to display reboot warning."
	fi
	
		# Sleep for the interval time between warnings.
	/usr/bin/logger "Sleeping for $mySleep seconds."
	sleep $mySleep
done

/usr/bin/logger "Rebooting computer."
/usr/bin/logger "Ending `/usr/bin/basename $0` $myVer."

exit 0
