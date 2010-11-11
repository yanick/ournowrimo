use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use ournowrimo;
use Dancer::Test;

route_exists [GET => '/graph'], 'a route handler is defined for /graph';
response_status_is ['GET' => '/graph'], 200, 'response status is 200 for /graph';

my $resp = get_response([ 'GET' => '/data' ]);

print $resp->{content};
