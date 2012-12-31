#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

use Text::Wrap;
use Time::Local;

if ($#ARGV != 1 ) {
   print "Usage: [perl] showmsg.pl <messagebase> <message number>\n";
   exit;
}

my $mb = $ARGV[0];
my $num = $ARGV[1];

my $handle = FTN::JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %msgheader;
my @subfields;
my $text;

if (!FTN::JAM::ReadMessage($handle,$num,\%msgheader,\@subfields,\$text)) {
   die "Failed to read message $num";
}

my %subfieldhash = @subfields;

my $fromname = $subfieldhash{FTN::JAM::Subfields::SENDERNAME};
my $fromaddr = $subfieldhash{FTN::JAM::Subfields::OADDRESS};
my $toname   = $subfieldhash{FTN::JAM::Subfields::RECVRNAME};
my $toaddr   = $subfieldhash{FTN::JAM::Subfields::DADDRESS};
my $subject  = $subfieldhash{FTN::JAM::Subfields::SUBJECT};

if (!$fromname) { $fromname = "<unknown>"; }
if (!$toname)   { $toname   = "<unknown>"; }
if (!$subject)  { $subject  = "<unknown>"; }

if ($fromaddr) { print "From: $fromname ($fromaddr)\n"; }
else           { print "From: $fromname\n"; }

if ($toaddr) { print "  To: $toname ($toaddr)\n"; }
else         { print "  To: $toname\n"; }

print "Subj: $subject\n"; 
print "Date: ",scalar localtime(FTN::JAM::LocalToTime($msgheader{DateWritten})),"\n";
print "\n";

$text =~ s/\x0D/\x0A/g;
$Text::Wrap::columns = 79;
print wrap("","",$text);

FTN::JAM::CloseMB($handle);
