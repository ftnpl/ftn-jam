#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] createmb.pl <messagebase> <basemsgnum>\n";
   exit;
}

my $mb = $ARGV[0];
my $basemsgnum = $ARGV[1];

my $handle = FTN::JAM::CreateMB($mb,$basemsgnum);

if(!$handle) {
   die "Failed to create $mb";
}

FTN::JAM::CloseMB($handle);
