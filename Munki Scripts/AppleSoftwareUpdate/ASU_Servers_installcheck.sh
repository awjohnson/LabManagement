#!/bin/bash

# ASU_Servers_installcheck.sh
# this will run as a munki install_check script
# exit status of 0 means install needs to run
# exit status not 0 means no installation necessary


#URL="http://my.UpdateServer.com/index_testing.sucatalog"
#URL="http://my.UpdateServer.com/index_production.sucatalog"
URL="http://my.UpdateServer.com/index_Servers.sucatalog"
#URL="http://my.UpdateServer.com/index_TLT-Staff.sucatalog"
#URL="http://my.UpdateServer.com/index_TV-Studio-Test.sucatalog"
#URL="http://my.UpdateServer.com/index_TV-Studio.sucatalog"
#URL="http://my.UpdateServer.com/index_CS-Testing.sucatalog"
#URL="http://my.UpdateServer.com/index_CS-Production.sucatalog"

CatalogURL=`/usr/bin/defaults read /Library/Preferences/com.apple.SoftwareUpdate CatalogURL`

if [ $CatalogURL != $URL ]; then
	/bin/echo "ASU_Servers: CatalogURL for ASU not set correctly."
	exit 0
fi

exit 1

