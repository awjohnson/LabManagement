#!/usr/bin/perl -w

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
#use File::Copy;

my $vers = "1.00";
my $log = LogName();


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

	# This subroutine will remove the printer not used for that user.
	# Pass $type as Zero.
sub delPrinter
{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	
	my @printList = `/usr/bin/lpstat -v | /usr/bin/sed s/\\ /:/g | /usr/bin/awk -F: '{print \$3}'`; chomp @printList;
# 	my @printList = `/usr/bin/lpstat -v 2>/dev/null | /usr/bin/sed s/\\ /:/g | /usr/bin/cut -d \":\" -f 3`;
# 	chomp @printList;
	foreach my $i (@printList)
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Deleting printer: $i\n";
		system("/usr/sbin/lpadmin -x $i 2>/dev/null");
	}

	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Ending " . $this_subs_name . ".\n";
}

sub CleanUp
{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	
	my $user = `/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow lastUserName`; chomp $user;
	my $homeDir = "/Users/" . $user;
	
		# Touching home directory.
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Touching " . $homeDir . "\n";
	system("/usr/bin/touch $homeDir");
		# Set the speaker volume to 0
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Setting the audio volume level."."\n";
	system("/usr/bin/osascript -e \"set volume 0\"");

	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Ending " . $this_subs_name . ".\n";
}

open(LOG,">>$log");
print LOG "\n" . TimeStamp() . " " . MyName() . "[". $$ . "]: " . "Starting " . MyName() . " " . $vers . "\n";

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Deleting triger file..." . "\n";
system("/bin/rm -Rf /Users/Shared/logoff/logoff");

	# Make logoff folder is invisible and accessibe by all...
system("/usr/bin/chflags hidden /Users/Shared/logoff");
system("/usr/sbin/chown root:wheel /Users/Shared/logoff/");
system("/bin/chmod 777 /Users/Shared/logoff/");
system("/usr/local/sinc/sinc-LogoffTracker.sh");

#delPrinter();
CleanUp();

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Ending " . MyName . " " . $vers . ".\n";
close(LOG);
exit;
