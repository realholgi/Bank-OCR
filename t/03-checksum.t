#!perl -T
use Modern::Perl;

use Test::More tests => 8;

use Bank::OCR;

my $ocr = Bank::OCR->new();

is ($ocr->has_valid_checksum('457508000'), 1, 'valid number');
isnt ($ocr->has_valid_checksum('664371495'), 1, 'invalid number');
is ($ocr->has_valid_checksum('86110??36'), undef, 'illegal number');
is ($ocr->has_valid_checksum('711111111'), 1, 'correct number'); 
is ($ocr->has_valid_checksum('000000051'), 1, 'correct number 00'); 


is ($ocr->checkmark('457508000'), '', 'check valid number');
is ($ocr->checkmark('664371495'), 'ERR', 'check invalid number');
is ($ocr->checkmark('86110??36'), 'ILL', 'check illegal number');
