#!perl -T
use Modern::Perl;

use Test::More tests => 11;

use Bank::OCR;

my $ocr = Bank::OCR->new();

my $valid_test_input = <<EOF;
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

 _  _  _  _  _  _  _  _    
| || || || || || || ||_   |
|_||_||_||_||_||_||_| _|  |
                           
    _  _  _  _  _  _     _ 
|_||_|| || ||_   |  |  | _ 
  | _||_||_||_|  |  |  | _| 
                           
    _  _     _  _  _  _  _ 
  | _| _||_| _ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _ 
                 
    _  _  _  _  _  _     _ 
|_||_|| || ||_   |  |  ||_ 
  | _||_||_||_|  |  |  | _|
 
EOF

my $obj = $ocr->parse_multiple($valid_test_input);
is ($obj->[0]->{account_number}, '123456789');
is ($obj->[0]->{checkmark}, '');
is ($obj->[1]->{account_number}, '000000051');
is ($obj->[1]->{checkmark}, '');
is ($obj->[2]->{account_number}, undef);
is ($obj->[2]->{checkmark}, '');
isnt ($obj->[2]->{error}, '');
is ($obj->[3]->{account_number}, '1234?678?');
is ($obj->[3]->{checkmark}, 'ILL');
is ($obj->[4]->{account_number}, '490067715');
is ($obj->[4]->{checkmark}, 'ERR');
