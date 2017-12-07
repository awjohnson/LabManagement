#!/bin/bash

# ASU_CS-Testing_postinstall.sh

#URL="http://asu.sinc.stonybrook.edu/index_testing.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_production.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_Servers.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TLT-Staff.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TV-Studio-Test.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TV-Studio.sucatalog"
URL="http://asu.sinc.stonybrook.edu/index_CS-Testing.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_CS-Production.sucatalog"

/bin/echo "ASU_CS-Testing: setting CatalogURL to: $URL"
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CatalogURL "$URL"

exit 0

