#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

if ($#ARGV != 4 ) {
   print "Usage: [perl] setlastread.pl <messagebase> <usercrc> <usernum> <lastreadmsg> <highreadmsg>\n";
   exit;
}

my $mb = $ARGV[0];

my $handle = FTN::JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %lastread;

$lastread{UserCRC}     = $ARGV[1];
$lastread{UserID}      = $ARGV[2];
$lastread{LastReadMsg} = $ARGV[3];
$lastread{HighReadMsg} = $ARGV[4];

if (!FTN::JAM::SetLastRead($handle,$ARGV[2],\%lastread)) {
   die "SetLastRead failed";
}

FTN::JAM::CloseMB($handle);
