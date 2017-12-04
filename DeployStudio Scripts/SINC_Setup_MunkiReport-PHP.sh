#!/bin/sh

# start here

/bin/bash -c "$(/usr/bin/curl -s https://munkimaster.sinc.stonybrook.edu/reporting/index.php?/install)"
/usr/bin/defaults write /Library/Preferences/MunkiReport BaseUrl "https://munkimaster.sinc.stonybrook.edu/reporting/"
exit 0
