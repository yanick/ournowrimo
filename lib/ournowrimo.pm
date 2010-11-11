package ournowrimo;

use 5.10.0;

use Dancer ':syntax';
use DateTime;
use DateTime::Format::Flexible;
use autodie;

my $count_file = 'count.dat';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/add' => sub {

    open my $fh, '>>', $count_file;

    say $fh join ',', DateTime->now, params->{who}, params->{count};

    close $fh;

    redirect '/';
};

get '/data' => sub {
    my %contestant;

    open my $fh, '<', $count_file;

    while (<$fh>) {
        chomp;
        my ( $date, $who, $count ) = split '\s*,\s*';

        $date = DateTime::Format::Flexible->parse_datetime($date);
        $contestant{$who}{ 1000 * $date->epoch } = $count;
    }

    my @json;

    while ( my ( $peep, $data ) = each %contestant ) {
        push @json,
          { label     => $peep,
            hoverable => \1,
            data =>
              [ map { [ $_, $data->{$_} ] } sort { $a <=> $b } keys %$data ],
          };
    }

    my $here = 50_000 * ( DateTime->now->epoch - DateTime::Format::Flexible->parse_datetime(
    "2010-11-01")->epoch ) / 
    (DateTime::Format::Flexible->parse_datetime("2010-12-01")->epoch -  DateTime::Format::Flexible->parse_datetime(
    "2010-11-01")->epoch );

    push @json, {
        label => 'de par',
        data => [
            [DateTime::Format::Flexible->parse_datetime( "2010-11-01")->epoch * 1000, 0],
            [ DateTime->now->epoch * 1_000, $here  ]
        ],

    };

    to_json( \@json );
};

true;
