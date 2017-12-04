#!/bin/sh

# start here

/usr/bin/dscl . -append /Groups/admin GroupMembership SUNYSB.EDU\\\!awjohnso
/usr/bin/dscl . -append /Groups/admin GroupMembership SUNYSB.EDU\\\!skepert

exit 0
