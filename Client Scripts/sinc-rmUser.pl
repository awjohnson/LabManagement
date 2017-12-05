#!/usr/bin/perl -w

#  Author: Andrew W. Johnson
#    Date: 2017.07.26
# Version: 3.01
#
# Minor bug:	If no argument selected, the program would throw an error.
# 				Removed the conditional around the argument check. Seems to work. 

#  Author: Andrew W. Johnson
#    Date: 2017.02.24
# Version: 3.00

# This script will remove old home directories, cache files related to that 
# user, and local LDAP for the cached AD user. Admin, /Users/Shared, and a 
# few other accounts are spared.
#
# Normally this script will be called everyday by a LaunchDaemon before 9am,
# and it will remove the users that are older then 3 days.
#
# Activity is logged in /var/.home/admin/Library/Logs. We don't want our clients
# being able to see the log, and possibly use it to stalk other users or for other
# personal gain.
#
# Added the following flags when calling the program to do the following:
#
#           Verbose: output to the console the same information going to the
#                    log and some additional pieces of information to better
#                    assist in troubleshooting.
#
#  Time Restriction: Turn off the time restriction. The script will normaly only
#                    run if it's before 9am.
#
# All User Deletion: Delete all users, ignoring the three day rule (minus the exceptions.)
#
#         No Delete: Perform the whole operation except it will not delete the
#                    users. Basically a preflight to be sure you are not
#                    deleting the wrong stuff.
#
# Finally, besides removing /Users/USERNAME it will look for cache files in the 
# following locations:
#
# /private/var/folders
# /private/var/db/dslocal/nodes/Default/groups/com.apple.sharepoint.group.X.plist where X is a number
# /private/var/db/dslocal/nodes/Default/sharepoints/FULLUSERNAME.plist
# In the local LDAP with DSCL /Local/Default/Users/USERNAME
# And if DSCL doesn't remove it, it will remove:
# /private/var/db/dslocal/nodes/Default/users/USERNAME.plist
# 
# These files are critical since if we accumulate too many of them the computers
# stop booting up.

use File::Basename;
use Cwd qw(abs_path);
use Sys::Hostname;
use File::Copy;

my $vers = "3.01";
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
	if (! -e "/var/.home/admin/Library/Logs" )
	{
		mkdir("/var/.home/admin/Library/Logs",0700);
		my $uid = `id -u admin`; chomp $uid;
		my $gid = `id -g admin`; chomp $gid;
		chown($uid, $gid, "/var/.home/admin/Library/Logs");
	}
	my $myName = MyName;
		# Get rid of the the .pl part 
	(my $Name) = split(/\./,$myName);
		# Add the path and the .log to the name.
	my $logName = "/var/.home/admin/Library/Logs/" . $Name . ".log";
	print "$logName\n";
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

	# Ensure root is running this script.
my $me = `/usr/bin/whoami`; chomp $me;
if ( $me ne "root" )
{
	print TimeStamp . " " . MyName . "[". $$ . "]: " . "This program needs to run as root." . "\n";
	exit;
}

open(LOG,">>$log");
print LOG "\n" . TimeStamp() . " " . MyName() . "[". $$ . "]: " . MyName() . " v" . $vers . " is starting!" . "\n";


#my $argument_count = @ARGV;
#if ($argument_count > 0 )
#{
if ( grep(/-v/,@ARGV) )
{
	$verbose = 1;
}
else
{
	$verbose = 0;
}
if ( grep(/-t/,@ARGV) )
{
	$time_restriction = 1;
}
else
{
	$time_restriction = 0;
}
if ( grep(/-a/,@ARGV) )
{
	$all_user_deletion = 1;
}
else
{
	$all_user_deletion = 0;
}
if ( grep(/-n/,@ARGV) )
{
	$no_delete = 0;
}
else
{
	$no_delete = 1;
}
if ( grep(/-h/,@ARGV) )
{
	print "usage:\t" . MyName . " [ ] [-a] [-n] [-t] [-v] [-h]\n\t \tNormal Run.\n\t-a\tDelete all users.\n\t-n\tNoDelete - Do not delete any of the files.\n\t-t\tRun regardless of time restriction.\n\t-v\tVerbose - besides the log, output to the command line.\n\t-h\tDisplay this help.\n\n"; 
	print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . MyName() . " v" . $vers . " is ending!" . "\n";
	close(LOG);
	exit;
}
print "Verbose = $verbose\nTime Restriction: $time_restriction\nAll User Deletion: $all_user_deletion\nNo User Deletion: $no_delete\n\n" if ( $verbose == 1 );
#}

my $days;

if ( $all_user_deletion == 1 )
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Delete all users option selected." . "\n";
	print "Delete all users option selected." . "\n" if ( $verbose == 1);
	$days = 0;
}
else
{
	$days = 3;
}

	# If it's not on troubleshooting mode, then restric this program from operating after 9am.
if ( $time_restriction == 0 )
{
		# get the current hour.
	$hour = `date "+%H"`;
	chomp $hour;
		# if after 9 am don't run.
	if ($hour >= 9 )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Exiting, as it's after 9:00 AM." . "\n";
		print "Exiting, as it's after 9:00 AM." . "\n" if ( $verbose == 1);
		print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . MyName() . " v" . $vers . " is ending!" . "\n";
		close(LOG);
		exit;
	}
}
else
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Time restriction bypassed." . "\n";
	print "Time restriction bypassed." . "\n" if ( $verbose == 1);
}

	# Get a list of users who are also local administrators.
my $dscl_admins = `/usr/bin/dscl . read /Groups/admin GroupMembership | /usr/bin/cut -c 18-999`; chomp $dscl_admins;
my @admins = split(/ /,$dscl_admins);

	# Add deamon, guest, nobody, sincconsult to the list of users not to be deleted
push (@admins, ( "daemon", "Guest" , "nobody", "sincconsult", "Shared" ));
print "Admins: @admins\n" if ( $verbose == 1 );

	# Get a list of users listed in the local domain.
my @users = `/usr/bin/find /Users/* -maxdepth 0`; chomp @users;

	# Find out who's logged in on the console.
my $isLoggedin = `/usr/bin/who | /usr/bin/egrep -i console | /usr/bin/egrep -vi mbsetupuser`; chomp $isLoggedin;
print "Users: @users\n" if ( $verbose == 1 );

foreach my $i(@users)
{
	my $homeDir = $i;
	my @client = split(/\//,$homeDir);
	my $arrLenth= @client; $arrLenth--;
	my $user = $client[$arrLenth];
	my $userCache;
	undef $userCache;
	
	print "User: $user\n" if ( $verbose == 1 );
		# Skip if said user is logged in on the console.
	if ( $user eq $isLoggedin )
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "It seems user: $user is logged in. Skipping." . "\n";
		print "It seems user: $user is logged in. Skipping." . "\n" if ( $verbose == 1 );
		next;
	}
		# If the user is listed in the admins group, then ignore.
	if ( grep(/$user/,@admins))
	{
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Found exception: $user, skipping." . "\n";
		print "Found exception: $user, skipping." . "\n" if ( $verbose == 1 );	
		next;
	}
			
		# If the home direcory is older then 3 days then proceed.
	if ( -M $homeDir >= $days )
	{
			# Remove the Home Directory.
		print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Removing: $homeDir as it's older then $days days." . "\n";
		print "Removing: $homeDir as it's older then $days days." . "\n" if ( $verbose == 1 );
		system("/bin/rm -Rf $homeDir") if ( $no_delete == 1 );
		
			# Remove the cache files.
		my $userCache = `/usr/bin/find /private/var/folders -user $user -maxdepth 2`; chomp $userCache;
		if ( $userCache ne "" )
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Removing: $userCache" . "\n";
			print "Removing: $userCache" . "\n" if ( $verbose == 1 );
			system("/bin/rm -Rf $userCache") if ( $no_delete == 1 );
		}
		else
		{
			undef $userCache;
		}
		
			# Finding and removing /private/var/db/dslocal/nodes/Default/groups/com.apple.sharepoint.group.X.plist
		my @plist = ();
		@plist = `/bin/ls -1 /private/var/db/dslocal/nodes/Default/groups | /usr/bin/egrep -i com.apple.sharepoint.group`; chomp @plist;
		my $isThere = 0;
		foreach my $z(@plist)
		{
			$isThere = `/usr/bin/defaults read /private/var/db/dslocal/nodes/Default/groups/$z users | /usr/bin/egrep -ic $user`; chomp $isThere;
			if ($isThere == 1)
			{
				$file = "/private/var/db/dslocal/nodes/Default/groups/" . $z;
				print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Removing file for user $user: $file" . "\n";
				print "Removing file for user $user: $file" . "\n" if ( $verbose == 1 );
				system("/bin/rm -Rf \"$file\"") if ( $no_delete == 1 );
				last;
			}
			elsif ( $isThere == 0 )
			{
				undef $file;
			}
		}

			# Finding and removing /private/var/db/dslocal/nodes/Default/sharepoints/FULLUSERNAME.plist
		undef $file;
		@plist = ();
		@plist = `/bin/ls -1 /private/var/db/dslocal/nodes/Default/sharepoints`; chomp @plist;
		$isThere = 0;
		foreach my $z(@plist)
		{
			$file = "/private/var/db/dslocal/nodes/Default/sharepoints/" . $z;
			$isThere = `/usr/bin/defaults read \"$file\" | /usr/bin/egrep -ic $user`; chomp $isThere;
			if ( $isThere == 1 )
			{
				print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Removing file for user $user: $file" . "\n";
				print "Removing file for user $user: $file" . "\n" if ( $verbose == 1 );
				system("/bin/rm -Rf \"$file\"") if ( $no_delete == 1 );
				last;
			}
			elsif ( $isThere == 0 )
			{
				undef $file;
			}
		}
			# Check to see if the user is in the local LDAP and remove the user entry.
		
		my $dscl_user = `/usr/bin/dscl . list /Users | /usr/bin/egrep -ic $user`; chomp $dscl_user;
		if ( $dscl_user == 1 )
		{
			print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Found user in local LDAP will now remove: $user" . "\n";
			print "Found user in local LDAP will now remove: $user" . "\n" if ( $verbose == 1 );
			system("/usr/bin/dscl . delete $homeDir") if ( $no_delete == 1 );
		}
		

			@plist = ();
			@plist = `/bin/ls -1 /private/var/db/dslocal/nodes/Default/users`; chomp @plist;

			undef $file;
			$isThere = 0;
			foreach my $z(@plist)
			{
				if ( $z =~ m/$user/ )
				{
					$file = "/private/var/db/dslocal/nodes/Default/users/" . $z;
					print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Removing file for $user: $file" . "\n";
					print "Removing file for $user: $file" . "\n";
					system("/bin/rm -Rf \"$file\"") if ( $no_delete == 1 );
					last;
				}
			}
	}
	
}

print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . MyName() . " v" . $vers . " is ending!" . "\n";
close(LOG);

exit;
