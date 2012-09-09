#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'FTN::JAM' );
    use_ok( 'FTN::JAM::Subfields' );
}

diag( "Testing FTN::JAM $FTN::JAM::VERSION, Perl $], $^X" );
