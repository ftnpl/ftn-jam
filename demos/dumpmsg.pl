#!/usr/local/bin/perl
#
# Small demonstration of JAM.pm

use JAM;

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

my $handle = JAM::OpenMB($mb);

if(!$handle) {
   die "Failed to open $mb";
}

my %baseheader;

if (!JAM::ReadMBHeader($handle,\%baseheader)) {
   die "Failed to read message header of $mb";
}

printf "Base header:\n";
printf "\n";
printf "  Signature: %s\n",$baseheader{Signature};
printf "DateCreated: 0x%08x (%s)\n",$baseheader{DateCreated},scalar localtime(JAM::LocalToTime($baseheader{DateCreated}));
printf " ModCounter: %d\n",$baseheader{ModCounter};
printf " ActiveMsgs: %d\n",$baseheader{ActiveMsgs};
printf "PasswordCRC: 0x%08x\n",$baseheader{PasswordCRC};
printf " BaseMsgNum: %d\n",$baseheader{BaseMsgNum};
printf "\n";

my %msgheader;
my @subfields;
my $text;

if (!JAM::ReadMessage($handle,$num,\%msgheader,\@subfields,\$text)) {
   die "Failed to read message $num";
}

printf "Message header:\n";
printf "\n";

printf "    Signature: %s\n",$msgheader{Signature};
printf "     Revision: %d\n",$msgheader{Revision};
printf " ReservedWord: 0x%04x\n",$msgheader{ReservedWord};
printf "  SubfieldLen: %d\n",$msgheader{SubfieldLen};
printf "     MsgIdCRC: 0x%08x\n",$msgheader{MsgIdCRC};
printf "     ReplyCRC: 0x%08x\n",$msgheader{ReplyCRC};
printf "      ReplyTo: %d\n",$msgheader{ReplyTo};
printf "     Reply1st: %d\n",$msgheader{Reply1st};
printf "    ReplyNext: %d\n",$msgheader{ReplyNext};
printf "  DateWritten: 0x%08x (%s)\n",$msgheader{DateWritten},scalar localtime(JAM::LocalToTime($msgheader{DateWritten}));
printf " DateReceived: 0x%08x (%s)\n",$msgheader{DateReceived},scalar localtime(JAM::LocalToTime($msgheader{DateReceived}));
printf "DateProcessed: 0x%08x (%s)\n",$msgheader{DateProcessed},scalar localtime(JAM::LocalToTime($msgheader{DateProcessed}));
printf "       MsgNum: %d\n",$msgheader{MsgNum};
printf "   Attributes: 0x%08x\n",$msgheader{Attributes};
printf "  Attributes2: 0x%08x\n",$msgheader{Attributes2};
printf "    TxtOffset: %d\n",$msgheader{TxtOffset};
printf "       TxtLen: %d\n",$msgheader{TxtLen};
printf "  PasswordCRC: 0x%08x\n",$msgheader{PasswordCRC};
printf "         Cost: %d\n",$msgheader{Cost};
printf "\n";

printf "Subfields:\n";
printf "\n";

for (my $i = 0; $i <= $#subfields; $i=$i+2) {
   printf "%4d: %s\n",$subfields[$i],$subfields[$i+1];
}

printf "\n";
    
printf "Text:\n";
printf "\n";

$text =~ s/\x0d/\x0a/g;
$Text::Wrap::columns = 79;
print wrap("","",$text);

JAM::CloseMB($handle);
