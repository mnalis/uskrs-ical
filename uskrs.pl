#!/usr/bin/perl -T
# by Matija Nalis <mnalis-perl@voyager.hr> GPLv3+ started 2015-11-15
# calculate easter and generate ICal

use strict;
use warnings;
use autodie;

my $VERSION='0.1';

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
SUMMARY:$e_name $e_year
DTSTART;VALUE=DATE:$event_date
DTEND;VALUE=DATE:$event_date
END:VEVENT

EOL
}  
  
sub one_easter($$$)
{
  return one_event ('Uskrs', @_);
}

# iCal header
print <<EOF;
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//voyager.hr//NONSGML uskrs.pl $VERSION//HR
X-WR-CALNAME:Uskrsi
EOF

# modify years range as needed in line below
foreach my $year (2015..2099) {
  # calculate Easter date. Voodoo magic calculations - see "2.9.6. Isn't there a simpler way to calculate Easter?" from https://web.archive.org/web/19970628070604/http://www.math.uio.no/faq/calendars/faq.html
  my $century = int($year/100);
  my $G = $year % 19;
  my $K = int(($century - 17)/25);
  my $I = ($century - int($century/4) - int(($century - $K)/3) + 19*$G + 15) % 30;
  $I = $I - int($I/28)*(1 - int($I/28)*int(29/($I + 1))*int((21 - $G)/11));
  my $J = ($year + int($year/4) + $I + 2 - $century + int($century/4)) % 7;
  my $L = $I - $J;
  my $EasterMonth = 3 + int(($L + 40)/44);
  my $EasterDay = $L + 28 - 31*int($EasterMonth/4);
  
  one_easter($year, $EasterMonth, $EasterDay);
}

# iCal footer
print <<EOF;
END:VCALENDAR
EOF
