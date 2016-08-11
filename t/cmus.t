#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use FindBin;
use Image::Rsvg;

chdir $FindBin::Bin;

require_ok ("Audio::Cmus");

done_testing();
exit;
