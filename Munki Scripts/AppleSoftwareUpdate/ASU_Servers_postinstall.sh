#!/bin/bash

# ASU_Servers_postinstall.sh

#URL="http://my.UpdateServer.com/index_testing.sucatalog"
#URL="http://my.UpdateServer.com/index_production.sucatalog"
URL="http://my.UpdateServer.com/index_Servers.sucatalog"
#URL="http://my.UpdateServer.com/index_TLT-Staff.sucatalog"
#URL="http://my.UpdateServer.com/index_TV-Studio-Test.sucatalog"
#URL="http://my.UpdateServer.com/index_TV-Studio.sucatalog"
#URL="http://my.UpdateServer.com/index_CS-Testing.sucatalog"
#URL="http://my.UpdateServer.com/index_CS-Production.sucatalog"

/bin/echo "ASU_Servers: setting CatalogURL to: $URL"
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CatalogURL "$URL"

exit 0

