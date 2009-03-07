#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;
use YAML;

use Railsish::Router::Route;

Railsish::Router::Route->draw(
    sub {
	my ($map) = @_;

	$map->connect(
	    "/dashboard/:year/:month/:date",
	    controller => "users",
	    action => "dashboard"
	);
    }
);

my $uri = Railsish::Router::Route::uri_for(
    controller => "users",
    action => "dashboard",
    year => "3009",
    month => "12",
    date => "23"
);

is($uri, "dashboard/3009/12/23");
