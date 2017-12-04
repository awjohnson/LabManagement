#!/usr/bin/perl -w

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
use File::Copy;

my $log = LogName();
my $vers="v1.00";
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

	# Subroutine that will brighten up the iMac displays on login.
sub iMacBrightness
{
	my $this_subs_name = (caller(0))[3];
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Starting ". $this_subs_name . ".\n";
	if ( -e "/usr/local/bin/brightness" )
	{
			# Find machine type to set the brightness on the iMacs.
		my $type=`/usr/sbin/system_profiler SPHardwareDataType 2>/dev/null | /usr/bin/egrep -i Identifier | /usr/bin/cut -d ":" -f 2 | /usr/bin/cut -c 2-5`; chomp $type;
			# If type is iMac set the brightness.
		if  ( $type eq "iMac" )
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": This computer is an iMac. Setting brightness: ";
			$result=`/usr/local/bin/brightness -d 0 -v 1`;
			chomp $result;
			print LOG $result . "\n";
		}
		else
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": This computer is not an iMac." . "\n";
		}
	}
	else
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": I can't find /usr/local/bin/brightness." ."\n";
	}
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $this_subs_name . ": Ending " . $this_subs_name . ".\n";
}

	# Open the log file and start logging.
open(LOG,">$log");
print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Starting " . MyName . " " . $vers . ".\n";

	# MAIN STARTS HERE!

iMacBrightness();

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Ending " . MyName . " " . $vers . ".\n";
close(LOG);
exit;
