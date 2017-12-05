#!/usr/bin/perl -w

# Idle options in minutes: 1,  2,   5,   10,  20,   30,   60,   Never (0).
# Idle options in seconds: 60, 120, 300, 600, 1200, 1800, 3600, Never (0).

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
use File::Copy;

my $log = LogName();
my $vers="v1.20";
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

	# Subroutine to change the screensaver settings if sincclass and sincconsult log in.
sub screenSaver
{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	
	my $computerName = `/usr/sbin/networksetup -getcomputername`; chomp $computerName; chop $computerName; chop $computerName;
	my $compName = lc($computerName);
	my $idle = 300;
	my $user = $_[0];
	my $safeLogoutWait = 10;
	my $userPath = "/Users";
	$userPath = "/var/.home" if ( $user eq "admin");
	
		# Set Idle time.
	$idle = 600 if ( $user eq "admin" );
#	$idle = 0 if ( $user eq "sincconsult" );
#	$idle = 1800 if ( $user eq "sincclass" );
#	$idle = 0 if ( $compName eq "sincprint" );
	$safeLogoutWait = 30 if ( $user eq "admin" );
#	$safeLogoutWait = 5 if ( $compName eq "lpm" );
#	$safeLogoutWait = 5 if ( $compName eq "upm" );
	
		# Figure out if it's a 3rd floor LLRC computer and adjust the idleTime accordingly.
	my $compName = lc(`/usr/sbin/networksetup -getcomputername`); chomp $compName;
	if ( $compName =~ /llm/ ) 
	{
		my $b = substr $compName, 3, 2;
		if (( $b >= 30 ) && ( $b <= 50 ))
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": 3rd Floor LLRC computer. Setting Idle time to 1800 seconds." . "\n";
			$idle = 1800
		}
	}
	
		# get the UUID since the plist file is a ByHost file.
	my $uuid = `/usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | /usr/bin/awk '/IOPlatformUUID/ { print \$3; }'  | /usr/bin/sed s/\\"//g`; chomp $uuid;
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": UUID: " . $uuid . "\n";

		# Put the whole path together from user name and UUID code.		
	my $file = $userPath . "/" . $user . "/Library/Preferences/ByHost/com.apple.screensaver." . $uuid . ".plist";
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Plist: " . $file . "\n";
		
		# Read the current idle time.
	my $idleTime = `/usr/bin/defaults read $file idleTime`; chomp $idleTime;
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Current IdleTime: " . $idleTime . "\n";
	
		# If idletime is not right, adjust it.
	if ( $idleTime != $idle )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Incorrect idle time. Resetting it..." . "\n";
			# Set idle time.
		#system ("/usr/bin/defaults write $file idleTime -int $idle");
		system("/usr/bin/defaults -currentHost write com.apple.screensaver idleTime -int $idle");
		$idleTime = `/usr/bin/defaults read $file idleTime`; chomp $idleTime;
		
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": New IdleTime: " . $idleTime . "\n";
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Changing permissions on logfile." . "\n";
		system("/bin/chmod 666 $log");
	}
	else
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Idle time is already correctly set. No need to change antyhing." . "\n";
	}
		# Set the which screensaver to use.
	system("/usr/bin/defaults -currentHost write com.apple.screensaver moduleDict '{ moduleName = \"LogOutAE\"; path = \"/Library/Screen Savers/LogOutAE.saver\"; }';");
	system("/usr/bin/defaults -currentHost write logoutae fontSize -int 60");
	system("/usr/bin/defaults -currentHost write logoutae forceLogoutWait -int 1");
	system("/usr/bin/defaults -currentHost write logoutae safeLogoutWait -int $safeLogoutWait");

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
my $homePath = "/Users";

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Checking to see if a user is specified." . "\n";
$user = `/usr/bin/who | /usr/bin/egrep -i console | /usr/bin/egrep -iv _mbsetupuser | /usr/bin/cut -d " " -f 1`; chomp $user;

while ( $user eq "" )
{	
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "No user specified." . "\n";
	sleep(1);
	$n++;
	$user = `/usr/bin/who | /usr/bin/egrep -i console | /usr/bin/cut -d " " -f 1`; chomp $user;
	last if ( $n == 15 );
}

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Checking to see if a home directory is available." . "\n";
$homePath = "/var/.home/" if ( $user eq "admin" );

$home = `/usr/bin/find $homePath -name $user -depth 1 2>/dev/null`; chomp $home;
$k = 0;

while ( $home eq "" )
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "No home found." . "\n";
	sleep(2);
	$k++;
	$home = `/usr/bin/find /$homePath -name $user -depth 1 2>/dev/null`; chomp $home;
	last if ( $k == 15 );
}

if (( $n <= 14 ) && ( $k <= 14 ))
{
	screenSaver($user);
}
else
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Oops... Something went wrong, I can't find a user logging in or a home directory..." . "\n";
}


print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Ending " . MyName . " " . $vers . ".\n";
close(LOG);
exit;

