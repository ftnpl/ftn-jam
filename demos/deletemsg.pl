#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] deletemsg.pl <messagebase> <message number>\n";
   exit;
}

my $mb = $ARGV[0];
my $num = $ARGV[1];

my $handle = FTN::JAM::OpenMB($mb);

my %msgheader;

if(!$handle) {
   die "Failed to open $mb";
}

if(!FTN::JAM::ReadMessage($handle,$num,\%msgheader,0,0)) {
   die "Failed to read message $num";
}

$msgheader{Attributes} |= FTN::JAM::Attr::DELETED;

if(!FTN::JAM::LockMB($handle,0)) {
   die "Failed to lock messagebase $mb";
}

if(!FTN::JAM::ChangeMessage($handle,$num,\%msgheader)) {
   die "Failed to delete message $num";
}

FTN::JAM::UnlockMB($handle);
FTN::JAM::CloseMB($handle);
