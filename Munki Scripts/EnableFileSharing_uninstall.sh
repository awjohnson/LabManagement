#!/bin/sh

# EnableFileSharing_uninstall.sh

/bin/echo "EnableFileSharing: Un-loading /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist"
/bin/launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist

exit 0

