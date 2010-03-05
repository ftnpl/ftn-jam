#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

use strict;
use warnings;

if ($#ARGV != 1 ) {
   print "Usage: [perl] locktest.pl <messagebase> <timeout>\n";
   exit;
}

my $mb = $ARGV[0];
my $timeout = $ARGV[1];

my $handle = JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

while (1) {
   if (!JAM::LockMB($handle,$timeout)) {
      die "Failed to lock $mb";
   }

   print "File locked. Press enter to unlock.\n";
   <STDIN>;

   JAM::UnlockMB($handle);

   print "File unlocked. Press enter to lock again.\n";
   <STDIN>;
}

