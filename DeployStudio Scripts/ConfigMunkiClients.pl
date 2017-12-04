#!/usr/bin/perl -w

use Date::Format;
use File::Basename;
use Cwd qw(abs_path);

my $version = "2.00";

	# Sanity check. Make sure it's executing as root or exits.
$me = `/usr/bin/whoami`; chomp $me;
print TimeStamp() . " " . MyName() . "[" . $$ , "]: " . MyName() . " v" . $version . " needs to execute as root!" . "\n" if ( $me ne "root" ); 
exit if ($me ne "root");

my $log = LogName();
open(LOG,">>$log") || die "I can't open the log file.";
print LOG "\n" . TimeStamp() . " " . MyName() . "[". $$ . "]: " . MyName() . " version $version" . "\n";

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
	my $homeDir = `/bin/echo \$HOME`; chomp $homeDir;
		# Add the path and the .log to the name.
	my $logName = "/Library/Logs/" . $Name . ".log";
#	print "$logName\n";
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

	# Subroutine to house all the data. This is what gets edited.
sub data
{
	# Format:
	#				"MachineName"	=>	"Manifest,MunkiServer,MunkiType,MunkiReport",
	
	my %settings = (	fam00	=>	"sierra/Testing/FAM-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb00	=>	"sierra/Testing/HYB-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim00	=>	"sierra/Testing/LIM-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm00	=>	"CAP/Testing/LLM-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						unm00	=>	"CAP/Testing/UNM-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr00	=>	"sierra/Testing/THR-Test,munkimaster,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						vader	=>	"YOS/Staff/Vader,munkimaster,staff",
						katiba	=>	"TLT-Staff/katiba,munkimaster,staff",
						macstaff01	=>	"YOS/Staff/test/Staff01,munkimaster,staff",
						macstu02	=>	"YOS/Staff/test/Base-Staff,munkimaster,staff",
						mattmac	=>	"TLT-Staff/mattmac,munkimaster,staff",
						dianamac	=>	"TLT-Staff/dianamac,,munkimaster,staff",
						bubbles	=>	"TLT-Staff/jenniferJ,munkimaster,staff",
						taramac	=>	"TLT-Staff/taramac,munkimaster,staff",
						techmacbook	=>	"TLT-Staff/techmacbook,munkimaster,Staff",
						tfcmac	=>	"TLT-Staff/tfcmac,munkilibrary,staff",
						"beaker-tll"	=>	"YOS/Custom/TLL-MacPro,munkilibrary,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"bender-tll"	=>	"CAP/TLL/iMac-TLL,munkimaster,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"bunsen-tll"	=>	"CAP/TLL/MacPro-TLL,munkilibrary,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"elzar-tll"	=>	"CAP/TLL/iMac-TLL,munkimaster,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"gonzo-tll"	=>	"YOS/Custom/TLL-MacPro,munkilibrary,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"grover-tll"	=>	"YOS/Custom/TLL-MacPro,munkilibrary,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"leela-tll"	=>	"CAP/TLL/iMac-TLL,munkimaster,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						"pazuzu-tll"	=>	"CAP/TLL/iMac-TLL,munkimaster,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						cms01	=>	"sierra/Custom/CMS,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam01	=>	"sierra/Custom/FAM-Instructor,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam02	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam03	=>	"sierra/Custom/FAM-Instructor,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam04	=>	"sierra/Custom/FAM-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam05	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam06	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam07	=>	"sierra/Custom/FAM-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam08	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam09	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam10	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam11	=>	"sierra/Custom/FAM-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam12	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam13	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam14	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam15	=>	"sierra/Custom/FAM-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam16	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam17	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam18	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam19	=>	"sierra/Custom/FAM-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam20	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam21	=>	"sierra/Custom/FAM-Consult,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						fam22	=>	"sierra/Custom/FAM,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb01	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb02	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb03	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb04	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb05	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb06	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb07	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb08	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb09	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb10	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb11	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb12	=>	"sierra/Custom/HYB-Instructor,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb13	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb14	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb15	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb16	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb17	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb18	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb19	=>	"sierra/Custom/HYB,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb20	=>	"sierra/Custom/HYB-Consult,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						hyb21	=>	"sierra/Custom/HYB-Scan,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m01	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m02	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m03	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m04	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m05	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m06	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m07	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m08	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m09	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m10	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m11	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m12	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m13	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m14	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m15	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m16	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m17	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m18	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m19	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m20	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m21	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m22	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m23	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m24	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m25	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m26	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m27	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m28	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m29	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m30	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m31	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m32	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m33	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m34	=>	"sierra/Custom/L4M,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						l4m35	=>	"sierra/Custom/L4M-Instructor,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm01	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm02	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm03	=>	"sierra/Custom/LCM-Scan,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm04	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm05	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm06	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm07	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm08	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm09	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm10	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm11	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm12	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lcm13	=>	"sierra/Custom/LCM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim01	=>	"sierra/Custom/LIM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim02	=>	"sierra/Custom/LIM-Scan,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim03	=>	"sierra/Custom/LIM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim04	=>	"sierra/Custom/LIM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim05	=>	"sierra/Custom/LIM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim06	=>	"sierra/Custom/LIM-Scan,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lim99	=>	"sierra/Custom/LIM99,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm01	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm02	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm03	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm04	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm05	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm06	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm07	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm08	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm09	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm10	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm11	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm12	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm13	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm14	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm15	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm16	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm17	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm18	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm19	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm20	=>	"sierra/Custom/LLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						llm21	=>	"sierra/Custom/LLM-Instructor,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						lpm01	=>	"sierra/Custom/LPM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mcm01	=>	"CAP/Custom/MCM,munkiecc,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						mcm02	=>	"CAP/Custom/MCM,munkiecc,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						mcm03	=>	"CAP/Custom/MCM,munkiecc,lab,16F5E897-CD4E-84BF-5890-578E2ABF7A18",
						mlm01	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm02	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm03	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm04	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm05	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm06	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm07	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm08	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm09	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm10	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm11	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm12	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm13	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm14	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm15	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm16	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm17	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm18	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm19	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm20	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm21	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm22	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm23	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm24	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm25	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm26	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm27	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						mlm28	=>	"sierra/Custom/MLM,munkilibrary,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc01	=>	"sierra/Custom/PHC-Instructor,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc02	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc03	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc04	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc05	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc06	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc07	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc08	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc09	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc10	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc11	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc12	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						phc13	=>	"sierra/Custom/PHC,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						shm01	=>	"sierra/Custom/SHM,MunkiSouthampton,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						shm02	=>	"sierra/Custom/SHM,MunkiSouthampton,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						shm03	=>	"sierra/Custom/SHM,MunkiSouthampton,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						shm04	=>	"sierra/Custom/SHM-Scan,MunkiSouthampton,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab01	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab02	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab03	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab04	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab05	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab06	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab07	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab08	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab09	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab10	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab11	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab12	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab13	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab14	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab15	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab16	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab17	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab18	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab19	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab20	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab21	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab22	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab23	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab24	=>	"sierra/Custom/TAB,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						tab25	=>	"sierra/Custom/TAB-Scan,munkiecc,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr01	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr02	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr03	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr04	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr05	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr06	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr07	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr08	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr09	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr10	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr11	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr12	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr13	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr14	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr15	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr16	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr17	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr18	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr19	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						thr20	=>	"sierra/Custom/THR,munkifinearts,lab,E2B1C747-475A-F68E-0616-68E0A00F481E",
						rti00	=>	"CAP/RTI/Clients/RTI00,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti01	=>	"CAP/RTI/Clients/RTI01,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti02	=>	"CAP/RTI/Clients/RTI02,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti03	=>	"CAP/RTI/Clients/RTI03,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti04	=>	"CAP/RTI/Clients/RTI04,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti05	=>	"CAP/RTI/Clients/RTI05,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti06	=>	"CAP/RTI/Clients/RTI06,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti07	=>	"CAP/RTI/Clients/RTI07,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti08	=>	"CAP/RTI/Clients/RTI08,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti09	=>	"CAP/RTI/Clients/RTI09,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti10	=>	"CAP/RTI/Clients/RTI10,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti11	=>	"CAP/RTI/Clients/RTI11,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti12	=>	"CAP/RTI/Clients/RTI12,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti13	=>	"CAP/RTI/Clients/RTI13,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti14	=>	"CAP/RTI/Clients/RTI14,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						rti15	=>	"CAP/RTI/Clients/RTI15,munkimaster,staff,FB52C21D-AB40-A6E5-3473-E51967AC38FA",
						bsbmac01	=>	"sierra/Custom/BSBMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						bsbmac02	=>	"sierra/Custom/BSBMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						bsbmac03	=>	"sierra/Custom/BSBMAC-Scan,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						bsbmac04	=>	"sierra/Custom/BSBMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						bsbmac05	=>	"sierra/Custom/BSBMAC-Color,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						eglmac01	=>	"sierra/Custom/EGLMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						eglmac02	=>	"sierra/Custom/EGLMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						espmac01	=>	"sierra/Custom/ESPMAC,munkilibrary,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						musmac01	=>	"sierra/Custom/MUSMAC,munkifinearts,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						musmac02	=>	"sierra/Custom/MUSMAC,munkifinearts,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						musmac03	=>	"sierra/Custom/MUSMAC,munkifinearts,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						musmac04	=>	"sierra/Custom/MUSMAC-Scan,munkifinearts,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195",
						phimac01	=>	"sierra/Custom/PHIMAC,munkiecc,lab,77EEC880-FFCA-AE96-65D2-8315B0FA7195"
					);
	return ($settings{"$_[0]"});
}

	# Get the computer name.
my $compName = `/usr/sbin/networksetup -getcomputername`; chomp $compName;
	# Make the computer name lower case.
$compName =~ tr/A-Z/a-z/;
	# Get the data for this computer name out of the hash residing in the data subroutine.
my $stuff = &data("$compName");
	# Split the data out into the three variables needed.
my ($ClientIdentifier, $munkiLocation, $MUNKITYPE, $MUNKIREPORT) = split(/,/,$stuff);

	# Setup the rest of the Munki preference file variables.
my $AppleSoftwareUpdatesOnly = "FALSE";
my $DaysBetweenNotifications = "1";
my $FollowHTTPRedirects = "none";
my $HelpURL = "http://service.stonybrook.edu";
my $InstallAppleSoftwareUpdates = "TRUE";
my $LogFile = "Library/Managed Installs/Logs/ManagedSoftwareUpdate.log";
my $LogToSyslog = "FALSE";
my $ManagedInstallDir = "/Library/Managed Installs";
my $PackageVerificationMode = "hash";
my $ShowRemovalDetail = "FALSE";
my $SoftwareRepoURL = "https://" . $munkiLocation . ".sinc.stonybrook.edu";
my $UseClientCertificate = "FALSE";

	# Lab vs Staff options.
if ( $MUNKITYPE eq "lab" )
{
	$InstallRequiresLogout = "TRUE";
	$SuppressAutoInstall = "TRUE";
	$SuppressStopButtonOnInstall = "TRUE";
	$SuppressUserNotification = "TRUE";
}
elsif ( $MUNKITYPE eq "staff" )
{
	$InstallRequiresLogout = "FALSE";
	$SuppressAutoInstall = "FALSE";
	$SuppressStopButtonOnInstall = "FALSE";
	$SuppressUserNotification = "FALSE";
}

	# Configure the settings.
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls AppleSoftwareUpdatesOnly -bool $AppleSoftwareUpdatesOnly");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls ClientIdentifier -string \"$ClientIdentifier\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls DaysBetweenNotifications -int $DaysBetweenNotifications");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls FollowHTTPRedirects -string \"$FollowHTTPRedirects\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls HelpURL -string \"$HelpURL\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls InstallAppleSoftwareUpdates -bool $InstallAppleSoftwareUpdates");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls InstallRequiresLogout -bool $InstallRequiresLogout");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls LogFile -string \"$LogFile\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls LogToSyslog -bool $LogToSyslog");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls ManagedInstallDir -string \"$ManagedInstallDir\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls PackageVerificationMode -string \"$PackageVerificationMode\"");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls ShowRemovalDetail -bool $ShowRemovalDetail");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL -string $SoftwareRepoURL");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls SuppressAutoInstall -bool $SuppressAutoInstall");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls SuppressStopButtonOnInstall -bool $SuppressStopButtonOnInstall");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls SuppressUserNotification -bool $SuppressUserNotification");
system("/usr/bin/defaults write /Library/Preferences/ManagedInstalls UseClientCertificate -bool $UseClientCertificate");

	# Print out the contents of the ManagedInstalles.plist file to the log.
@result = `/usr/bin/defaults read /Library/Preferences/ManagedInstalls.plist | /usr/bin/egrep -iv [{}] | /usr/bin/sed s/\\ //g | /usr/bin/sed s/=/\\ =\\ /g`; chomp @result;

foreach my $i(@result)
{
	print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . $i . "\n";
}

	# Additional settings for MunkiReport

system("/usr/bin/defaults write /Library/Preferences/MunkiReport Passphrase $MUNKIREPORT");

	# Setting the Apple Software Update catalog to the Production catalog, since it's the most conservative one. Munki can then do what it wants.

system("/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CatalogURL -string \"http://asu.sinc.stonybrook.edu/index_production.sucatalog\"");
$result = `/usr/bin/defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CatalogURL`; chomp $result;

print LOG TimeStamp . " " . MyName . "[". $$ . "]: " . "Apple Software Update Catalog set to: " . $result . "\n";

	# Kick off Munki now.
if (! -e "/Users/Shared/.com.googlecode.munki.checkandinstallatstartup" )
{
	print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . "Creating the kickstart file: /Users/Shared/.com.googlecode.munki.checkandinstallatstartup." . "\n";
	system("/usr/bin/touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup");
	if ( -e "/Users/Shared/.com.googlecode.munki.checkandinstallatstartup" )
	{
		print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . "I was successful in creating /Users/Shared/.com.googlecode.munki.checkandinstallatstartup." . "\n";
	}
	else
	{
		print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . "I wasn't successful in creating /Users/Shared/.com.googlecode.munki.checkandinstallatstartup." . "\n";
	}
}
else
{
	print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . "The kickstart file /Users/Shared/.com.googlecode.munki.checkandinstallatstartup already exists." . "\n";
}


print LOG TimeStamp() . " " . MyName . "[". $$ . "]: " . MyName() . " is all done. I will now terminate!" . "\n";
close (LOG);

exit;


