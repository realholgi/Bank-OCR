#!perl -T
use Modern::Perl;

use Test::More tests => 11;

use Bank::OCR;

my $ocr = Bank::OCR->new();

my @valid_test_input=(
'    _  _     _  _  _  _  _ ',
'  | _| _||_||_ |_   ||_||_|',
'  ||_  _|  | _||_|  ||_| _|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '123456789', 'valid 123456789');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'| || || || || || || || || |',
'|_||_||_||_||_||_||_||_||_|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '000000000', 'valid 0s');

@valid_test_input=(
'                           ',
'  |  |  |  |  |  |  |  |  |',
'  |  |  |  |  |  |  |  |  |',
' ',
);
is ($ocr->parse(@valid_test_input), '111111111', 'valid 1s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
' _| _| _| _| _| _| _| _| _|',
'|_ |_ |_ |_ |_ |_ |_ |_ |_ ',
'                           ',
);
is ($ocr->parse(@valid_test_input), '222222222', 'valid 2s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
' _| _| _| _| _| _| _| _| _|',
' _| _| _| _| _| _| _| _| _|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '333333333', 'valid 3s');

@valid_test_input=(
'                           ',
'|_||_||_||_||_||_||_||_||_|',
'  |  |  |  |  |  |  |  |  |',
'                           ',
);
is ($ocr->parse(@valid_test_input), '444444444', 'valid 4s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'|_ |_ |_ |_ |_ |_ |_ |_ |_ ',
' _| _| _| _| _| _| _| _| _|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '555555555', 'valid 5s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'|_ |_ |_ |_ |_ |_ |_ |_ |_ ',
'|_||_||_||_||_||_||_||_||_|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '666666666', 'valid 6s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'  |  |  |  |  |  |  |  |  |',
'  |  |  |  |  |  |  |  |  |',
'                           ',
);
is ($ocr->parse(@valid_test_input), '777777777', 'valid 7s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'|_||_||_||_||_||_||_||_||_|',
'|_||_||_||_||_||_||_||_||_|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '888888888', 'valid 8s');

@valid_test_input=(
' _  _  _  _  _  _  _  _  _ ',
'|_||_||_||_||_||_||_||_||_|',
' _| _| _| _| _| _| _| _| _|',
'                           ',
);
is ($ocr->parse(@valid_test_input), '999999999', 'valid 9s');
