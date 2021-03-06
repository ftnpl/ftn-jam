#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

use Time::Local;

if ($#ARGV != 0 ) {
   print "Usage: [perl] listbase.pl <messagebase>\n";
   exit;
}

my $mb = $ARGV[0];

my $handle = FTN::JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %baseheader;

if (!FTN::JAM::ReadMBHeader($handle,\%baseheader)) {
   die "Failed to read messagebase header of $mb";
}

print "DateCreated: ",scalar localtime(FTN::JAM::LocalToTime($baseheader{DateCreated})),"\n";
print " BaseMsgNum: $baseheader{BaseMsgNum}\n";
print " ActiveMsgs: $baseheader{ActiveMsgs}\n";
print "\n";

my $nummsgs;

if (!FTN::JAM::GetMBSize($handle,\$nummsgs)) {
   die "Failed to get size of messagebase $mb";
}

print "Total message entries in index file: $nummsgs\n";
print "\n";

printf("       %-20.20s %-20.20s %-20.20s\n","From","To","Subject");
print "\n";

for (my $i = $baseheader{BaseMsgNum}; $i < $baseheader{BaseMsgNum}+$nummsgs; $i++)
{
   my %msgheader;
   my @subfields;

   if (!FTN::JAM::ReadMessage($handle,$i,\%msgheader,\@subfields,0)) {
      printf("%6s Failed to open message\n",$i);
   }
   else {
      my %subfieldhash = @subfields;

      my $from = $subfieldhash{FTN::JAM::Subfields::SENDERNAME};
      my $to   = $subfieldhash{FTN::JAM::Subfields::RECVRNAME};
      my $subj = $subfieldhash{FTN::JAM::Subfields::SUBJECT};

      if (!$from) { $from = "<empty>"; }
      if (!$to)   { $to   = "<empty>"; }
      if (!$subj) { $subj = "<empty>"; }
  
      printf("%6s %-20.20s %-20.20s %-20.20s\n",$i,$from,$to,$subj);
   }
}

FTN::JAM::CloseMB($handle);
