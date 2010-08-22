use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'FTN::JAM',
    AUTHOR              => 'Robert James Clay <jame@rocasa.us>',
    VERSION_FROM        => 'lib/FTN/JAM.pm',
    ABSTRACT_FROM       => 'lib/FTN/JAM.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Time::Local' => 0,
        'Time::Zone' => 0,
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ftn-jam-*' },
);
