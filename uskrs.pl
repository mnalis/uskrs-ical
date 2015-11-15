#!/usr/bin/perl -T
# by Matija Nalis <mnalis-perl@voyager.hr> GPLv3+ started 2015-11-15
# calculate easter and generate ICal

use strict;
use warnings;
use autodie;

use Date::Calc qw(Easter_Sunday Add_Delta_Days);

my $VERSION='0.2';
my $year_start = 2015;
my $year_end = 2099;

# returns current time in YYYYMMDD T HHMMSS Z format
sub time_now()
{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
    return sprintf ("%04d%02d%02dT%02d%02d%02dZ", $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

# prints one iCal event
sub one_event
{
  my ($e_name, $e_year, $e_mon, $e_day) = @_;
  my $event_date = sprintf ("%04d%02d%02d", $e_year, $e_mon, $e_day);
  my $now = time_now();

  print <<EOL;
BEGIN:VEVENT
CREATED:$now
LAST-MODIFIED:$now
DTSTAMP:$now
UID:$e_name-$e_year
SUMMARY:$e_name $e_year (neradni)
DTSTART;VALUE=DATE:$event_date
DTEND;VALUE=DATE:$event_date
END:VEVENT

EOL
}  
  
sub one_easter($$$)	{ return one_event ('Uskrs', @_) }
sub one_eas_mon($$$)	{ return one_event ('Uskršnji pon.', Add_Delta_Days(@_, 1)) }
sub one_tjelovo($$$)	{ return one_event ('Tjelovo', Add_Delta_Days(@_, 9*7-3)) }

# iCal header
print <<EOF;
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//voyager.hr//NONSGML uskrs.pl $VERSION//HR
X-WR-CALNAME:Uskrs i tjelovo
EOF

# modify years range as needed in line below
foreach my $year ($year_start..$year_end) {
    my ($year, $EasterMonth, $EasterDay) = Easter_Sunday($year);
    one_easter ($year, $EasterMonth, $EasterDay);	# uskrs (Easter)
    one_eas_mon($year, $EasterMonth, $EasterDay);  	# uskrsnji pon. (monday after Easter)
    one_tjelovo($year, $EasterMonth, $EasterDay);  	# Tjelovo (Corpus Christi)
}

# iCal footer
print <<EOF;
END:VCALENDAR
EOF
