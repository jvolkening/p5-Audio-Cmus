use 5.012;

use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Audio::Cmus',
    license            => 'perl',
    dist_author        => q{Jeremy Volkening <jdv@base2bio.com>},
    configure_requires => {
        'Module::Build'       => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
    },
    meta_merge => {
        resources => {
            repository => 'https://github.com/jvolkening/p5-Audio-Cmus'
        }
    },
    add_to_cleanup => [ 'Audio-Cmus-*' ],
    create_license => 1,
);
$builder->create_build_script;
