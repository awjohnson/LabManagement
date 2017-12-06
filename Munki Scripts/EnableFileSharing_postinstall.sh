#!/bin/sh

# EnableFileSharing_postinstall.sh

/bin/echo "EnableFileSharing: Loading /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist"

/bin/launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist

exit 0
