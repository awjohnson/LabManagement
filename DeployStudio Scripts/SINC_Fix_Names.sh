#!/bin/sh

# start here
#!/bin/bash

namefix=`/usr/sbin/scutil --get ComputerName`
/usr/sbin/scutil --set HostName "$namefix"

exit 0
