#!/bin/bash

/usr/bin/chflags hidden /Users/Shared/login
/usr/sbin/chown root:wheel /Users/Shared/login
/bin/chmod 777 /Users/Shared/login

/bin/rm /Users/Shared/login/trigger

/usr/local/sinc/sinc-iMacBrightness.pl
# /usr/local/sinc/sinc-SleepDisable.pl
/usr/local/sinc/sinc-adminStuff.pl
# /usr/local/sinc/sinc-DesktopWallpaper.pl
#/usr/local/sinc/sinc-printers.pl
/usr/local/sinc/sinc-permissions.pl
# /usr/local/sinc/sinc-unlockSaver.sh
/usr/local/sinc/sinc-LoginTracker.sh

exit 0