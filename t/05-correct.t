#!perl -T
use Modern::Perl;

use Test::More tests => 13;

use Bank::OCR;

my $ocr = Bank::OCR->new();

is ($ocr->try_correction('111111111', 1, 7), '711111111', 'try 1-7');
is ($ocr->try_correction('777777777', 7, 1), '777777177', 'try 7-1');
is ($ocr->try_correction('200000000', 0, 8), '200800000', 'try 8-8');
is ($ocr->try_correction('333333333', 3, 9), '333393333', 'try 3-9');

is ($ocr->correct('111111111'), '711111111');
is ($ocr->correct('777777777'), '777777177');
is ($ocr->correct('200000000'), '200800000');
is ($ocr->correct('333333333'), '333393333', 'double try');

is_deeply( [ sort $ocr->correct('888888888') ], [sort ['888888988', '888888880', '888886888']], 'AMB 8');
is_deeply( [ sort $ocr->correct('555555555') ], [sort ['559555555', '555655555' ]], 'AMB 5');
is_deeply( [ sort $ocr->correct('666666666') ], [sort ['666566666', '686666666' ]], 'AMB 6');
is_deeply( [ sort $ocr->correct('999999999') ], [sort ['899999999', '993999999', '999959999']], 'AMB 9');
is_deeply( [ sort $ocr->correct('490067715') ], [sort ['490067115', '490067719', '490867715']], 'AMB 4');




