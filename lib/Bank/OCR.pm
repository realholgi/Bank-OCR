package Bank::OCR;

use Modern::Perl;
use POSIX;

our $VERSION = '1.0';

Bank::OCR->run unless caller;

sub run {
	my $ocr = Bank::OCR->new();
    my $input;
    {
        local $/ = undef;
        $input = <>;
    }
    say $ocr->to_string( $ocr->parse_multiple($input) );
}

sub new {
    bless {}, shift;
}

sub validate {
    my ( $self, @lines ) = @_;

    return ( 'no lines at all', undef ) unless @lines;

    # 4 lines required
    return ( '4 lines required', undef ) if ( $#lines != 3 );

    # 27 characters in first 3 lines and only space, | _ allowed
    foreach my $index ( 0 .. 2 ) {
        my $line = $lines[$index];
        return ( "line $index length is " . length($line) . " but must be 27", undef ) if ( length($line) != 27 );
        return ( "line $index contains illegal characters", undef ) if ( $line !~ /^[\s_|]*$/ );
    }

    # last line only whitespace
    return ( 'last line not empty', undef ) if ( $#lines == 3 && $lines[3] !~ /^\s*$/ );

    return ( '', 1 );
}

sub parse {
    my ( $self, @lines ) = @_;

    my ( $error, $validated ) = $self->validate(@lines);
    return ( $error, undef ) unless defined $validated;

    my %number_pattern = (
        '     |  |' => 1,
        ' _  _||_ ' => 2,
        ' _  _| _|' => 3,
        '   |_|  |' => 4,
        ' _ |_  _|' => 5,
        ' _ |_ |_|' => 6,
        ' _   |  |' => 7,
        ' _ |_||_|' => 8,
        ' _ |_| _|' => 9,
        ' _ | ||_|' => 0,
    );

    my $res = '';
    foreach my $c ( 0 .. 8 ) {
        my $charPattern = '';
        foreach my $l ( 0 .. 2 ) {
            $charPattern .= substr $lines[$l], $c * 3, 3;
        }
        $res .= ( defined $number_pattern{$charPattern} )
					? $number_pattern{$charPattern}
					: '?';
    }
    return ( '', $res );
}

sub has_valid_checksum {
    my ( $self, $number ) = @_;

    return unless $number && isdigit $number;

    my $checksum   = 0;
    my $multiplier = 9;
    foreach my $c ( split //, $number ) {
        $checksum += $c * $multiplier--;
    }
    return ( $checksum % 11 == 0 );
}

sub correct {
    my ( $self, $number ) = @_;

    return unless defined $number && $number ne '';
    return $number if has_valid_checksum($number);
    if ($number =~ /\?{1}/) {
        	my $try = $self->try_guessing_number($number);
        	return $try if defined $try;
    }
    return $number unless isdigit $number;
	
    my @results = ();
    push @results, $self->do_try( $number, 9, 8 );
    push @results, $self->do_try( $number, 3, 9 );
    push @results, $self->do_try( $number, 1, 7 );
	push @results, $self->do_try( $number, 5, 9 );
	push @results, $self->do_try( $number, 5, 6 );
    push @results, $self->do_try( $number, 0, 8 );
    push @results, $self->do_try( $number, 8, 6 );
	
	return ( scalar @results == 1 ) ? $results[0] :  \@results; # '[ '. join(', ', map { "'$_'" } @results) . ' ]';
}

sub do_try {
    my ( $self, $number, $search, $replace ) = @_;

    return ( $self->try_correction( $number, $search,  $replace ), $self->try_correction( $number, $replace, $search ) );
}

sub try_correction {
    my ( $self, $number, $search, $replace ) = @_;

    my @results = ();
    foreach my $idx ( 0 .. length($number) ) {
        if ( substr( $number, $idx, 1 ) eq $search ) {
            my $try = $number;
            substr( $try, $idx, 1 ) = $replace;
            push @results, $try if $self->has_valid_checksum($try);
        }
    }
    return ( scalar @results == 1 ) ? $results[0] : @results;
}

sub checkmark {
    my ( $self, $number ) = @_;

    return '' unless $number;
    return 'AMB' if ref $number;
    
    my $checksum = $self->has_valid_checksum($number);

    return '' if $checksum;
    return 'ILL' unless ( defined $checksum );

    return 'ERR';
}

sub parse_multiple {
    my ( $self, $input_text ) = @_;

    my $res = [];
    return unless $input_text;
    my @lines = split /\n/m, $input_text;
    while (@lines) {
        my @block = splice( @lines, 0, 4 );
        my ( $error, $number ) = $self->parse(@block);
        my $c_number = $self->correct( $number );
        my $part = {
            account_number => $c_number,
            detected_number=> $number,
            checkmark      => $self->checkmark($c_number),
            original       => join "\n", @block
        };
        $part->{error} = $error if ($error);

        push @$res, $part;
    }
    return $res;
}

sub try_guessing_number {
	 my ( $self, $number ) = @_;
	 
	 foreach my $c ( 0..9 ) {
		my $try = $number;
		$try =~ s/\?/$c/;
		return $try if $self->has_valid_checksum($try);
    }
    return;
}

sub to_string {
    my ( $self, $obj ) = @_;

    return unless $obj;

    my $res = '';
    foreach my $account (@$obj) {
        if ( $account->{account_number} ) {
            $res .= "$account->{account_number} $account->{checkmark}\n";
        }
        else {
            $res .= "ERROR: $account->{error}\n";
        }
    }
    return $res;
}

1;    # End of Bank::OCR

