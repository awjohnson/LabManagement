#!/bin/sh

# start here

/usr/bin/dscl . -append /Groups/admin GroupMembership SUNYSB.EDU\\\!awjohnso
/usr/bin/dscl . -append /Groups/admin GroupMembership SUNYSB.EDU\\\!skepert
/usr/bin/dscl . -append /Groups/admin GroupMembership SUNYSB.EDU\\pstdenis
/usr/bin/dscl . -create /Groups/admin NestedGroups 8143569D-5D75-4F79-A40B-BE29CA477551

exit 0
