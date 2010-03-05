#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] setlastread.pl <messagebase> <usernum>\n";
   exit;
}

my $mb = $ARGV[0];

my $handle = JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %lastread;

if (!JAM::GetLastRead($handle,$ARGV[1],\%lastread)) {
   die "GetLastRead failed ($JAM::Errnum)";
}

foreach (keys %lastread) {
   print "$_: $lastread{$_}\n";
}

JAM::CloseMB($handle);
