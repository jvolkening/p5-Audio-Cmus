#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use FindBin;
use Audio::Cmus;

chdir $FindBin::Bin;

require_ok ("Audio::Cmus");

done_testing();
exit;
