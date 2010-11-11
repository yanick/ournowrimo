#!/usr/bin/perl 

use strict;
use warnings;
use autodie;
use DateTime::Format::Flexible;

my %contestants;

open my $fh, '<', 'count.dat';


while ( <$fh> ) {
    chomp;
    my( $date, $who, $count ) = split '\s*,\s*';

    $date = DateTime::Format::Flexible->parse_datetime( $date );
    $contestants{$who}{1000*$date->epoch} = $count;
}

use Data::Dumper;

print Dumper \%contestants;



