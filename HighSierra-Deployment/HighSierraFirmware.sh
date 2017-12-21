#!/bin/bash

# HighSierraFirmware.sh
# Version: 1.0
# 2017.12.21
#
# This script will search for the InstallESD.dmg file inside the Install macOS High Sierra.app 
# bundle residing in the /Applications folder so it can build the firmware package.
#
# This script makes use of the information provided by Darren Wallace
# from OS X & iOS Enterprise Tips, News & Resources found at: 
# http://www.amsys.co.uk/2017/09/deploying-firmware-updates-imaging/#comment-87790
#
# The script will also need munki-pkg found here: https://github.com/munki/munki-pkg.
# Munki-pkg needs to reside somewhere in the home directory of the user running the script.
# In my case it's in ~/bin.


	# Setting up some Aliases.
alias defaults="/usr/bin/defaults"
alias egrep="/usr/bin/egrep"
alias awk="/usr/bin/awk"
alias sed="/usr/bin/sed"
alias cp="/bin/cp"
alias hdiutil="/usr/bin/hdiutil"
alias pkgutil="/usr/sbin/pkgutil"
alias open="/usr/bin/open"
alias df="/bin/df"
alias diskutil="/usr/sbin/diskutil"
alias echo="/bin/echo"
alias plutil="/usr/bin/plutil"
alias rm="/bin/rm"
alias find="/usr/bin/find"
alias dirname="/usr/bin/dirname"

	# Some Variables
myIdentifier="edu.stonybrook.sinc.HighSierraFirmware"

echo ""

	# Search for the InstallESD.dmg file.
myInstallESD=`find /Applications -name InstallESD.dmg -print -quit`
echo Found: $myInstallESD

	# Search for the InstallInfo.plist file.
myPath=`dirname "$myInstallESD"`
myInstallInfo=`find "$myPath" -name InstallInfo.plist -print -quit`
echo Found: $myInstallInfo


	# Find munkipkg which hopefully is somewhere in the users home directory.
munkipkg=`find ~ -name munkipkg -print -quit 2>/dev/null`
echo "Found: $munkipkg"


	# Extract the OS version of the installer.
OSVersion=`defaults read "$myInstallInfo" "Payload Image Info" | egrep -i version | awk '{print $3}' | sed s/\"//g | sed s/\;//g`
echo "macOS version to be used: $OSVersion."

	# Mount the InstallESD.dmg to extract firmware.
echo "Mounting Install.dmg."
hdiutil mount -quiet "$myInstallESD"

	# Check to see if it has mounted. If not, then exit.
hasMounted=`df | egrep -ic InstallESD`
if [ $hasMounted -ne 1 ]; then
	echo "InstallESD.dmg failed to mount. Exiting."
	exit 1
else
	echo "InstallESD.dmg has mounted successfully."
fi

	# Searching for the FirmwareUpdate.pkg
FirmwareUpdate=`find /Volumes/InstallESD -name FirmwareUpdate.pkg -print -quit`
echo "Found: $FirmwareUpdate"

#read -n 1 -s

	# Expand the Firmware package to /tmp.
echo "Expanding the Firmware package."
pkgutil --expand "$FirmwareUpdate" /tmp/FirmwareUpdate

	# Use munkipkg to start creating a package structure for the Firmware.
echo "Creating package project."
$munkipkg --create /tmp/HighSierraFirmware

	# Write the package identifier to the plist to properly build the package
echo "Writing identifier to build-info.plist."
defaults write /tmp/HighSierraFirmware/build-info.plist identifier $myIdentifier

	# Make the version number the same as the OS number.
echo "Writing package version to build-info.plist."
defaults write /tmp/HighSierraFirmware/build-info.plist version $OSVersion

	# Convert build-info.plist back to XML from Binary.
echo "Converting build-info.plist back to xml from binary."
plutil -convert xml1 /tmp/HighSierraFirmware/build-info.plist

	# Copy the post install scripts to our new package location.
echo "Copying the scripts over."
cp /tmp/FirmwareUpdate/Scripts/postinstall_actions/update /tmp/HighSierraFirmware/scripts/postinstall
cp -R /tmp/FirmwareUpdate/Scripts/Tools /tmp/HighSierraFirmware/scripts/

	# Make the new package.
echo "Making the new package."
$munkipkg /tmp/HighSierraFirmware

	# Unmount InstallESD.
echo "Unmounting volume InstallESD."
diskutil unmount /Volumes/InstallESD


	# Cleanup, remove the directory with the expanded package from the installer.
echo "Removing /tmp/FirmwareUpdate"
rm -Rf /tmp/FirmwareUpdate

	# Pop open the folder containing the newly created package.
open /tmp/HighSierraFirmware/build

echo "All done."
echo ""

exit 0

