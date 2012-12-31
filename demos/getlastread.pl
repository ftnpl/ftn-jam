#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] setlastread.pl <messagebase> <usernum>\n";
   exit;
}

my $mb = $ARGV[0];

my $handle = FTN::JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %lastread;

if (!FTN::JAM::GetLastRead($handle,$ARGV[1],\%lastread)) {
   die "GetLastRead failed ($FTN::JAM::Errnum)";
}

foreach (keys %lastread) {
   print "$_: $lastread{$_}\n";
}

FTN::JAM::CloseMB($handle);
