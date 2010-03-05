#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

use strict;
use warnings;

use Text::Wrap;
use Time::Timezone;
use Time::Local;

if ($#ARGV != 1 ) {
   print "Usage: [perl] showmsg.pl <messagebase> <message number>\n";
   exit;
}

my $mb = $ARGV[0];
my $num = $ARGV[1];

my $handle = JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %msgheader;
my @subfields;
my $text;

if (!JAM::ReadMessage($handle,$num,\%msgheader,\@subfields,\$text)) {
   die "Failed to read message $num";
}

my %subfieldhash = @subfields;

my $fromname = $subfieldhash{JAM::Subfields::SENDERNAME};
my $fromaddr = $subfieldhash{JAM::Subfields::OADDRESS};
my $toname   = $subfieldhash{JAM::Subfields::RECVRNAME};
my $toaddr   = $subfieldhash{JAM::Subfields::DADDRESS};
my $subject  = $subfieldhash{JAM::Subfields::SUBJECT};

if (!$fromname) { $fromname = "<unknown>"; }
if (!$toname)   { $toname   = "<unknown>"; }
if (!$subject)  { $subject  = "<unknown>"; }

if ($fromaddr) { print "From: $fromname ($fromaddr)\n"; }
else           { print "From: $fromname\n"; }

if ($toaddr) { print "  To: $toname ($toaddr)\n"; }
else         { print "  To: $toname\n"; }

print "Subj: $subject\n"; 
print "Date: ",scalar localtime(JAM::LocalToTime($msgheader{DateWritten})),"\n";
print "\n";

$text =~ s/\x0D/\x0A/g;
$Text::Wrap::columns = 79;
print wrap("","",$text);

JAM::CloseMB($handle);
