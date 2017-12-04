#!/usr/bin/perl -w

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
use File::Copy;

my $log = LogName();
my $vers="v2.11";
	# Subroutine to detetmine the full path to this program.
sub pathToMe
{
	my $path = abs_path($0);
	$path = dirname($path);
	return $path;
}

	# Subroutine to determine the program name.
sub MyName
{
	my $path = abs_path($0);
	$name = basename($path);
	return $name;
}

	# Subroutine to determine the log name based on the name of the executable.
sub LogName
{
	my $myName = MyName;
		# Get rid of the the .pl part 
	(my $Name) = split(/\./,$myName);
		# Add the path and the .log to the name.
	my $logName = "/private/tmp/" . $Name . ".log";
	return $logName;
}

	# Subroutine to determine the date and time for logging purposes.
sub TimeStamp
{
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	my $year = 1900 + $yearOffset;
	$hour = sprintf("%.2d", $hour);
	$minute = sprintf("%.2d", $minute);
	$second = sprintf("%.2d", $second);
	$dayOfMonth = sprintf("%.2d", $dayOfMonth);
	my $theTime = "$months[$month] $dayOfMonth $hour:$minute:$second";
	return $theTime;
}


sub adminStuff

{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	
		# Setting Admin Desktop Background.
	my $AdminWallpaper = `/usr/bin/find /Users/Shared/DesktopPictures -name "*Admin*"`; chomp $AdminWallpaper;
	system("/usr/bin/sqlite3 /var/.home/admin/Library/Application\\ Support/Dock/desktoppicture.db \"update data set value = '$AdminWallpaper'\"");

		# Make the admin dir invisible & change permissions.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Hiding folder:" . "\n";
	my @results =`/usr/bin/chflags -v hidden /var/.home/admin`; chomp @results;
	foreach my $i(@results)
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ":\t" . $i . "\n";
	}
		
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Changing permissions:" . "\n";
	@results =`/bin/chmod -v 700 /var/.home/admin 2>/dev/null`; chomp @results;
	foreach my $i(@results)
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ":\t" . $i . "\n";
	}

		# Disable transparency in the menu bar and elsewhere on Yosemite
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Disable transparency in the menu bar and elsewhere on Yosemite." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.universalaccess reduceTransparency -bool true");
		
		# Set sidebar icon size to medium
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Set sidebar icon size to medium." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain NSTableView/usr/bin/defaultsizeMode -int 2");

		# Expand save panel by default
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Expand save panel by default." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true");

		# Expand print panel by default
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Expand print panel by default." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true");

		# Save to disk (not to iCloud) by default
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Save to disk (not to iCloud) by default." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false");

		# Automatically quit printer app once the print jobs complete
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Automatically quit printer app once the print jobs complete." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.print.PrintingPrefs \"Quit When Finished\" -bool true");

		# Disable “natural” (Lion-style) scrolling
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Disable “natural” (Lion-style) scrolling." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false");

		# Finder: show status bar
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Finder: show status bar." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowStatusBar -bool true");

		# Finder: show path bar
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Finder: show path bar." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowPathbar -bool true");

		# Avoid creating .DS_Store files on network volumes
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Avoid creating .DS_Store files on network volumes." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true");

		# Prevent Time Machine from prompting to use new hard drives as backup volume
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Prevent Time Machine from prompting to use new hard drives as backup volume." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true");

		# Enable spring loading for directories
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Enable spring loading for directories." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write NSGlobalDomain com.apple.springing.enabled -bool true");

		# Use the system-native print preview dialog
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Use the system-native print preview dialog." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.google.Chrome DisablePrintPreview -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.google.Chrome.canary DisablePrintPreview -bool true");

		# Set Desktop as the default location for new Finder windows
		# For other paths, use `PfLo` and `file:///full/path/here/`
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Set Desktop as the default location for new Finder windows." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder NewWindowTarget -string \"PfDe\"");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder NewWindowTargetPath -string \"file://\${HOME}/Desktop/\"");

		# Show icons for hard drives, servers, and removable media on the desktop
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Show icons for hard drives, servers, and removable media on the desktop." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowMountedServersOnDesktop -bool true");
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true");

		# Use icon view in all Finder windows by default
		# Four-letter codes for the other view modes: `Nlsv`, `clmv`, `Flwv`
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Use icon view in all Finder windows by default." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.finder FXPreferredViewStyle -string \"icnv\"");
	
		# Disable Resume system-wide
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Disable Resume system-wide." . "\n";
	system("/usr/bin/sudo -u admin /usr/bin/defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false");

		# Disable Notification Center and remove the menu bar icon
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Disable Notification Center and remove the menu bar icon." . "\n";
	system("/bin/launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null");

		# Disable local Time Machine backups
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Disable local Time Machine backups." . "\n";
	system("/usr/bin/hash tmutil &> /dev/null && sudo tmutil disablelocal");

	if ( -e "/usr/local/bin/dockutil" )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Resetting the Dock..." . "\n";
		system("/usr/local/bin/dockutil -v --remove all --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/BBEdit.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/Safari.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/Utilities/Terminal.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/Utilities/Disk\\ Utility.app --no-restart >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /System/Library/CoreServices/Applications/Directory\\ Utility.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /System/Library/CoreServices/Applications/Network\\ Utility.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/System\\ Preferences.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/Utilities/Console.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add /Applications/Utilities/Activity\\ Monitor.app --no-restart /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
		system("/usr/local/bin/dockutil -v --add afp://medea.sinc.stonybrook.edu/Software --label 'Software' /var/.home/admin >> /private/tmp/dockutil.log 2>&1");
	}
	else
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Can't find dockutil, can't reset the Dock." . "\n";
	}

		# Kill the finder to see the changes made.
	system("/usr/bin/killall Finder");

		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Ending " . $this_subs_name . ".\n";
}

	# Open the log file and start logging.
open(LOG,">$log");
print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Starting " . MyName . " " . $vers . ".\n";

# MAIN STARTS HERE!

	# Make sure there is a user logging in and, a home directory exists before
	# proceeding.

my $user = "";
my $home = "";
my $n = 0;
print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Checking to see if a user is specified." . "\n";
$user = `/usr/bin/who | /usr/bin/egrep -i console | /usr/bin/egrep -iv _mbsetupuser | /usr/bin/cut -d " " -f 1`; chomp $user;

while ( $user eq "" )
{	
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "No user specified." . "\n";
	sleep(1);
	$n++;
	$user = `/usr/bin/who | /usr/bin/egrep -i console | /usr/bin/egrep -iv _mbsetupuser | /usr/bin/cut -d " " -f 1`; chomp $user;
	last if ( $n == 15 );
}
print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Found: " . $user . "\n";

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Checking to see if a home directory is available." . "\n";
$home = `/usr/bin/find /var/.home -name $user -depth 1 2>/dev/null`; chomp $home;
$k = 0;

while ( $home eq "" )
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "No home found." . "\n";
	sleep(2);
	$k++;
	$home = `/usr/bin/find /var/.home -name $user -depth 1 2>/dev/null`; chomp $home;
	last if ( $k == 15 );
}
print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Found: " . $home . "\n";

if (( $n <= 14 ) && ( $k <= 14 ))
{
	if ( $user eq "admin" )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Administrator is logging in, proceeding..." . "\n";
		adminStuff();
	}
	else
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Non administrator is logging in, nothing to do..." . "\n";
	}
}
else
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Oops... Something went wrong, I can't find a user logging in or a home directory..." . "\n";
}

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Ending " . MyName . " " . $vers . ".\n";
close(LOG);
exit;

