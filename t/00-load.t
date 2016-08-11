#!perl -T
use 5.012;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Audio::Cmus' ) || print "Bail out!\n";
}

diag( "Testing Audio::Cmus $Audio::Cmus::VERSION, Perl $], $^X" );
