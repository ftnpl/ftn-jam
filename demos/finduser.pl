#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

use Time::Timezone;
use Time::Local;

if ($#ARGV != 1 ) {
   print "Usage: [perl] listbase.pl <messagebase> <toname>\n";
   exit;
}

my $mb = $ARGV[0];
my $usercrc = FTN::JAM::Crc32($ARGV[1]);

my $handle = FTN::JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %baseheader;

if (!FTN::JAM::ReadMBHeader($handle,\%baseheader)) {
   die "Failed to read messagebase header of $mb";
}

my $start = $baseheader{BaseMsgNum};
my $found;

while ($found = FTN::JAM::FindUser($handle,$usercrc, $start)) {
   my %msgheader;
   my @subfields;

   if (!FTN::JAM::ReadMessage($handle,$found,\%msgheader,\@subfields,0)) {
      printf("%6s Failed to open message\n",$found);
   }
   else {
      my %subfieldhash = @subfields;

      my $from = $subfieldhash{FTN::JAM::Subfields::SENDERNAME};
      my $to   = $subfieldhash{FTN::JAM::Subfields::RECVRNAME};
      my $subj = $subfieldhash{FTN::JAM::Subfields::SUBJECT};

      if (!$from) { $from = "<empty>"; }
      if (!$to)   { $to   = "<empty>"; }
      if (!$subj) { $subj = "<empty>"; }
  
      printf("%6s %-20.20s %-20.20s %-20.20s\n",$found,$from,$to,$subj);
   }
   
   
   $start = $found+1;
}

FTN::JAM::CloseMB($handle);
