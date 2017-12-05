- **sinc-rmUser.pl**: This script will remove old home directories, cache files related to that user, and local LDAP information for the cached AD user. Admin, /Users/Shared, and a few other accounts are spared. It is called from a LaunchDaemon: _edu.stonybrook.sinc.rmuser.plist_.
- **edu.stonybrook.sinc.rmuser.plist**: LaunchDaemon to run rmUser.pl every morning at 8am, usually before the labs open up.
- **sinc-nightreboot.sh**: This script will reboot the lab computers very early in the morning. Should there be a user logged in, BigHonkingText (https://github.com/kitzy/bighonkingtext) is used to bring up a warning to the user at T-10, T-5 and T-1 before reboot occurs. It is called by the LaunchDaemon: _edu.stonybrook.sinc.nightreboot.plist_.
- **edu.stonybrook.sinc.nightreboot.plist**: LaunchDaemon to launch sinc-nightreboot.sh.