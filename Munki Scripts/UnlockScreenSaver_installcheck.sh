#!/bin/sh

# UnlockScreenSaver_installcheck.sh
# this will run as a Munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary

ExitStatus=`/bin/cat /etc/pam.d/screensaver | /usr/bin/egrep -c '^# account    required       pam_group.so no_warn deny group=admin,wheel ruser fail_safe$'`

exit $ExitStatus
