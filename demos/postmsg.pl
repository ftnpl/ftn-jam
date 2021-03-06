#!/usr/local/bin/perl
#
# Small demonstration of FTN::JAM.pm

use FTN::JAM;

use strict;
use warnings;

use Getopt::Long;

my %opts;

my $getopt_res = GetOptions(\%opts, 'fromname=s', 
                                    'fromaddr=s', 
                                    'toname=s',
                                    'toaddr=s',
                                    'subject=s',
                                    'file=s',
                                    'help|h'  );
            
if ( !$getopt_res or $opts{help} or $#ARGV != 0) {
   print "\n";
   print "Usage: [perl] postmsg.pl <messagebase>\n";
   print "\n";
   print "Valid options are:\n";
   print "\n";
   print " --fromname <name>\n";
   print " --fromaddr <addr>\n";
   print " --toname <name>\n";
   print " --toaddr <addr>\n";
   print " --subject <string>\n";
   print " --file <filename>\n";
   print "\n";
   
   exit (0);
}                   

my $mb = $ARGV[0];

my $handle = FTN::JAM::OpenMB($mb);

if (!$handle) {
   die "Failed to open $mb";
}

if (!FTN::JAM::LockMB($handle,0)) {
   die "Failed to lock messagebase $mb";
}

my %msgheader;
my %subfields;
my @subfields;

my $text = "";

if ($opts{fromname}) { $subfields{FTN::JAM::Subfields::SENDERNAME} = $opts{fromname}; }
if ($opts{fromaddr}) { $subfields{FTN::JAM::Subfields::OADDRESS}   = $opts{fromaddr}; }
if ($opts{toname}) { $subfields{FTN::JAM::Subfields::RECVRNAME}    = $opts{toname}; }
if ($opts{toaddr}) { $subfields{FTN::JAM::Subfields::DADDRESS}     = $opts{toaddr}; }
if ($opts{subject}) { $subfields{FTN::JAM::Subfields::SUBJECT}     = $opts{subject}; }

@subfields = %subfields;

$msgheader{DateWritten} = FTN::JAM::TimeToLocal(time);

if ($opts{file}) {
   open (FILE,$opts{file}) or die "Failed to open $opts{file}";
   
   while (<FILE>) {
      s/\s+$//;
      $text = $text.$_.chr(13);
   }
   close (FILE);
}

my $num = FTN::JAM::AddMessage($handle,\%msgheader,\@subfields,\$text);

if ($num) {
   print "Added as message number $num\n";
}
else {
   print "Failed to add message\n";
}

FTN::JAM::UnlockMB($handle);
FTN::JAM::CloseMB($handle);
