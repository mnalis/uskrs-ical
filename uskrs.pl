#!/usr/bin/perl -T
# by Matija Nalis <mnalis-perl@voyager.hr> GPLv3+ started 2015-11-15
# calculate easter and generate ICal
# see "2.9.6. Isn't there a simpler way to calculate Easter?" from https://web.archive.org/web/19970628070604/http://www.math.uio.no/faq/calendars/faq.html

use strict;
use warnings;
use autodie;

sub one_easter($$$)
{
  my ($year, $mon, $day) = @_;
  print "$year = $mon/$day\n";
}

# modify years range as needed in line below
foreach my $year (2015..2099) {
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

