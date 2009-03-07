package Railsish::Router::Route;
use strict;
use warnings;

use Railsish::Router;

my $ROUTE;

sub draw {
    my ($class, $cb) = @_;
    unless ($ROUTE) {
	$ROUTE = Railsish::Router->new;
    }

    $cb->($ROUTE);
    return $ROUTE;
}

sub uri_for {
    $ROUTE->uri_for(@_)
}

1;
