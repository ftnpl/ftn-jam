#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'FTN::JAM' );
}

diag( "Testing FTN::JAM $FTN::JAM::VERSION, Perl $], $^X" );
