
- **logout.sh**: This script runs at login by a LuanchAgent. It just sits around waiting to detect a logout event. It then drops a file in a hidden LaunchDaemoned watched folder which will then trigger the rest of the scripts to execute as root. Thank you Apple for getting rid of LogoutHooks.
- **edu.stonybrook.sinc.logouthook.plist**: LaunchAgent that will start up logout.sh. Thank you Apple for getting rid of LogoutHooks.
- **sinc-logoff.pl**: This script is triggered by the LaunchDaemon which is watching the invisible folder _/Users/Shared/logoff_ for a trigger file. In the old days it deleted printers, no longer necessary. It also mutes the volume, so if a comptuer is rebooted at the login window, it won't make nosie in doing so. It also touches the home directory of the user logging out, to ensure we have a last possible used time stamp on it for the home directory purge script. Finally it also calles our home brewed LogoffTracker script.
- **edu.stonybrook.sinc.runlogoff.plist**: LaunchDaemon watching _/Users/Shared/logoff_ for a trigger file. Once triggered, it will run sinc-logoff.pl.
- **sinc-LogoffTracker.sh**: Our homebrewed login/logoff tracker.
