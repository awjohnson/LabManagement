Scripts and such for macOS High Sierra 10.13.x.

- **HighSierraFirmware.sh**: This script will search for the InstallESD.dmg file inside the Install macOS High Sierra.app bundle residing in the /Applications folder so it can build the firmware package.

This script makes use of the information provided by Darren Wallace from OS X & iOS Enterprise Tips, News & Resources found at: 
http://www.amsys.co.uk/2017/09/deploying-firmware-updates-imaging/#comment-87790

This also makes use of munki-pkg found here: https://github.com/munki/munki-pkg. Munki-pkg needs to reside somewhere in the home directory of the user running the script. In my case it's in ~/bin.
