#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

use strict;
use warnings;

use Time::Timezone;
use Time::Local;

if ($#ARGV != 0 ) {
   print "Usage: [perl] listbase.pl <messagebase>\n";
   exit;
}

my $mb = $ARGV[0];

my $handle = JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %baseheader;

if (!JAM::ReadMBHeader($handle,\%baseheader)) {
   die "Failed to read messagebase header of $mb";
}

print "DateCreated: ",scalar localtime($baseheader{DateCreated}-tz_local_offset()+timegm(0, 0, 0, 1, 0, 70)),"\n";
print " BaseMsgNum: $baseheader{BaseMsgNum}\n";
print " ActiveMsgs: $baseheader{ActiveMsgs}\n";
print "\n";

my $nummsgs;

if (!JAM::GetMBSize($handle,\$nummsgs)) {
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

   if (!JAM::ReadMessage($handle,$i,\%msgheader,\@subfields,0)) {
      printf("%6s Failed to open message\n",$i);
   }
   else {
      my %subfieldhash = @subfields;

      my $from = $subfieldhash{JAM::Subfields::SENDERNAME};
      my $to   = $subfieldhash{JAM::Subfields::RECVRNAME};
      my $subj = $subfieldhash{JAM::Subfields::SUBJECT};

      if (!$from) { $from = "<empty>"; }
      if (!$to)   { $to   = "<empty>"; }
      if (!$subj) { $subj = "<empty>"; }
  
      printf("%6s %-20.20s %-20.20s %-20.20s\n",$i,$from,$to,$subj);
   }
}

JAM::CloseMB($handle);
