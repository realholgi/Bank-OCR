#!perl -T
use Modern::Perl;

use Test::More tests => 4;

use Bank::OCR;

my $ocr = Bank::OCR->new();

is ($ocr->correct('111111111'), '711111111');
is ($ocr->correct('777777777'), '777777177');
is ($ocr->correct('200000000'), '200800000');
is ($ocr->correct('333333333'), '333393333');
