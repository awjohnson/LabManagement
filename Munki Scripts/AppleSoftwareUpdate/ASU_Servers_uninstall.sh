#/bin/bash

# ASU_Production_uninstall.sh

/bin/echo "ASU_Production: Deleting CatalogURL."

/usr/bin/defaults delete /Library/Preferences/com.apple.SoftwareUpdate CatalogURL

exit 0
