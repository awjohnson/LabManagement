#!/usr/bin/perl -w

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
use File::Copy;

my $log = LogName();
my $vers="v2.02";

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

sub permissions
{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	
	my $user = $_[0];
	my $gid=`/usr/bin/id -g $user`; chomp $gid;
	my $homeDir = "/Users/" . $user;
	
		# Make the ShortCuts dir invisible just in case it isn't.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Hiding the shortcuts folder." . "\n";
	system("/usr/bin/chflags hidden /Users/Shared/ShortCuts 2>/dev/null");
	
		# Make ~/Library/LaunchAgents in case it doesn't exist.
	if ( ! -e "$homeDir/Library/LaunchAgents")
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Making $homeDir/Library/LaunchAgents." . "\n";
		@answer = `/bin/mkdir -v $homeDir/Library/LaunchAgents`; chomp @answer;
		foreach my $i(@answer)
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": " . $i . "\n";
		}
		
	}
		# Change ownership of the home Directory
 	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Changing ownership on the HomeDir." . "\n";
	system("/usr/sbin/chown -R $user:$gid $homeDir 2>/dev/null");
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Changing permissions on the HomeDir." . "\n";
	system("/bin/chmod 700 $homeDir 2>/dev/null");
	
	
		# Set the speaker volume to 11
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Setting the audio volume level."."\n";
	system("/usr/bin/osascript -e \"set volume 6\"");
		# Properly set left and right balance.
	system("/usr/bin/osascript -e \"set volume output volume (output volume of (get volume settings))\"");
	
		# Set audio inputs and outputs in eMedia SINC Site.
	system("/usr/local/bin/audiodevice output \"Scarlett 2i2 USB\"") if ( -x "/usr/local/bin/audiodevice" );
	system("/usr/local/bin/audiodevice input \"Scarlett 2i2 USB\"") if ( -x "/usr/local/bin/audiodevice" );

		# Remove Google Chrome updater LaunchAgent.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Removing $homeDir/Library/LaunchAgents/com.google.keystone.agent.plist."."\n" if ( -e "$homeDir/Library/LaunchAgents/com.google.keystone.agent.plist");
	system("/bin/rm -f $homeDir/Library/LaunchAgents/com.google.keystone.agent.plist") if ( -e "$homeDir/Library/LaunchAgents/com.google.keystone.agent.plist");
	system("/bin/rm -Rf /Users/$user/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle");
	system("/bin/mkdir -p /Users/$user/Library/Google/GoogleSoftwareUpdate/");
	system("/usr/bin/touch /Users/$user/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle");
	system("/usr/sbin/chown root /Users/$user/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle");
	system("/bin/chmod 644 /Users/$user/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle");
	



		# Remove com.apple.AppStoreUpdateAgent.plist LaunchAgent.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Removing /System/Library/LaunchAgents/com.apple.AppStoreUpdateAgent.plist"."\n" if ( -e "/System/Library/LaunchAgents/com.apple.AppStoreUpdateAgent.plist");
	system("/bin/rm -f /System/Library/LaunchAgents/com.apple.AppStoreUpdateAgent.plist") if ( -e "/System/Library/LaunchAgents/com.apple.AppStoreUpdateAgent.plist");

		# Block ~/Library/LaunchAgents.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Blocking $homeDir/Library/LaunchAgents" . "\n" if ( -e "$homeDir/Library/LaunchAgents");
	system("/bin/chmod 000 $homeDir/Library/LaunchAgents");






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

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Checking to see if a home directory is available." . "\n";
$home = `/usr/bin/find /Users -name $user -depth 1 2>/dev/null`; chomp $home;
$k = 0;

while ( $home eq "" )
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "No home found." . "\n";
	sleep(2);
	$k++;
	$home = `/usr/bin/find /Users -name $user -depth 1 2>/dev/null`; chomp $home;
	last if ( $k == 15 );
}

if (( $n <= 14 ) && ( $k <= 14 ))
{
	if ( $user ne "admin" )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "A non administrator is logging in, proceeding..." . "\n";
		permissions($user);
	}
	else
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Administrator is logging in, nothing to do..." . "\n";
	}
}
else
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Oops... Something went wrong, I can't find a user logging in or a home directory..." . "\n";
}


print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Ending " . MyName . " " . $vers . ".\n";
close(LOG);
exit;
