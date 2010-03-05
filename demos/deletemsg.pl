#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] deletemsg.pl <messagebase> <message number>\n";
   exit;
}

my $mb = $ARGV[0];
my $num = $ARGV[1];

my $handle = JAM::OpenMB($mb);

my %msgheader;

if(!$handle) {
   die "Failed to open $mb";
}

if(!JAM::ReadMessage($handle,$num,\%msgheader,0,0)) {
   die "Failed to read message $num";
}

$msgheader{Attributes} |= JAM::Attr::DELETED;

if(!JAM::LockMB($handle,0)) {
   die "Failed to lock messagebase $mb";
}

if(!JAM::ChangeMessage($handle,$num,\%msgheader)) {
   die "Failed to delete message $num";
}

JAM::UnlockMB($handle);
JAM::CloseMB($handle);
