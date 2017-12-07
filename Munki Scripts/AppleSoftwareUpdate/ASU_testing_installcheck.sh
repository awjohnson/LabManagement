#!/bin/bash

# ASU_testing_installcheck.sh
# this will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary


URL="http://asu.sinc.stonybrook.edu/index_testing.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_production.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_Servers.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TLT-Staff.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TV-Studio-Test.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_TV-Studio.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_CS-Testing.sucatalog"
#URL="http://asu.sinc.stonybrook.edu/index_CS-Production.sucatalog"

CatalogURL=`/usr/bin/defaults read /Library/Preferences/com.apple.SoftwareUpdate CatalogURL`

if [ $CatalogURL != $URL ]; then
	/bin/echo "ASU_testing: CatalogURL for ASU not set correctly."
	exit 0
fi

exit 1

