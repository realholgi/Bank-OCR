#!perl -T
use Modern::Perl;

use Test::More tests => 7;

use Bank::OCR;

my $ocr = Bank::OCR->new();

isnt ($ocr->validate(undef), 1, 'undef');
isnt ($ocr->validate('123456789'), 1, 'only one line');

my @test_input_3lines=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_   ||_||_|',
'  ||_  _|  | _||_|  ||_| _|',
);
isnt ($ocr->validate(@test_input_3lines), 1, 'without empty line');

my @test_input_one_line_too_short=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_   ||_||_|',
'  ||_  _|  | _||_|  ||_||',
'                           ',
);
isnt ($ocr->validate(@test_input_one_line_too_short), 1, 'too short line');


my @test_only_valid_chars=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_ * ||_||_|',
'  ||_  _|  | _||_|  ||_| _|',
'                           ',
);
isnt ($ocr->validate(@test_only_valid_chars), 1, 'invalid char');

my @test_only_spaces_allowed_in_last_line=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_   ||_||_|',
'  ||_  _|  | _||_|  ||_| _|',
'_|                  ',
);
isnt ($ocr->validate(@test_only_spaces_allowed_in_last_line), 1, 'only spaces in last line');

my @valid_test_input=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_   ||_||_|',
'  ||_  _|  | _||_|  ||_| _|',
'',
);
is ($ocr->validate(@valid_test_input), 1, 'valid example');


