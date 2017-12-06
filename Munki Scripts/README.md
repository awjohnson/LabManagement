
- **DisableGateKeeper_installcheck.sh** / **DisableGateKeeper_postinstall.sh**: After security updates GateKeeper gets re-enabled. In our enviroment we still need it off. This way, when Munki runs every night, it checks and turns it back off if needed.
- **EnableARD_installcheck.sh** / **EnableARD_postinstall.sh**: This script will check and if off, turn on ARD. THis script was cribbed from http://scriptingosx.com.
- **EnableFileSharing_installcheck.sh** / **EnableFileSharing_postinstall.sh** / **EnableFileSharing_uninstallcheck.sh** / **EnableFileSharing_uninstall.sh**: Munki scripts to check and enable and disable File Sharing on the client computers.
