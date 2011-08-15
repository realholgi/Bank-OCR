use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Bank::OCR',
    AUTHOR              => q{Holger Eiboeck <holger@eiboeck.de>},
    VERSION_FROM        => 'lib/Bank/OCR.pm',
    ABSTRACT_FROM       => 'lib/Bank/OCR.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'artistic')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Bank-OCR-*' },
);
