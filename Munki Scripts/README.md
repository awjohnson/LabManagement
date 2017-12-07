
- **addAdmins_installcheck.sh**/**addAdmins_postinstall.sh**: Checks and adds Active Directory admin accoiunt (they start with an ! hence the escaping sequence needed) to the local admininstrator group.
- **DisableGateKeeper_installcheck.sh** / **DisableGateKeeper_postinstall.sh**: After security updates GateKeeper gets re-enabled. In our enviroment we still need it off. This way, when Munki runs every night, it checks and turns it back off if needed.
- **EnableARD_installcheck.sh** / **EnableARD_postinstall.sh**: This script will check and if off, turn on ARD. THis script was cribbed from http://scriptingosx.com.
- **EnableFileSharing_installcheck.sh** / **EnableFileSharing_postinstall.sh** / **EnableFileSharing_uninstallcheck.sh** / **EnableFileSharing_uninstall.sh**: Munki scripts to check and enable and disable File Sharing on the client computers.
- **SleepDisabled_installcheck.sh** / **SleepDisabled_postinstall.sh**: Disables the ability for the user to put the computer to sleep. The issue we had (have?) is that when a user is logged in, and the computer sleeps, if we remotely wake it, it will quickly go back to sleep if the console is not unlocked.
- **UnlockPrinters_installcheck.sh**/**UnlockPrinters_postinstall.sh**: This enables non admin endusers to unpause a paused print queue.
- **UnlockScreenSaver_installcheck.sh**/**UnlockScreenSaver_postinstall.sh**: This allowes the Adminstrators to unlock the console if an enduser has it locked. It used to be possible bafore macOS changes, now it's trickier.
- **enableSSH_installcheck.sh**/**enableSSH_postinstall.sh**/**enableSSH_uninstall.sh**: This script will check and if off, turn on SSH. THis script was cribbed from http://scriptingosx.com.
