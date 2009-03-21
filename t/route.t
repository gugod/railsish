#!/usr/bin/env perl -w
use strict;
use Test::More tests => 4;

use Railsish::Router;

Railsish::Router->draw(
    sub {
	my ($map) = @_;

	$map->connect(
	    "/dashboard/:year/:month/:date",
	    controller => "users",
	    action => "dashboard"
	);

        $map->connect("/:controller/:action/:id");
    }
);

my $uri = Railsish::Router->uri_for(
    controller => "users",
    action => "dashboard",
    year => "3009",
    month => "12",
    date => "23"
);

is($uri, "dashboard/3009/12/23");

my $matched = Railsish::Router->match("/admin/show/123");

if ($matched) {
    my $mapping = $matched->mapping;
    is $mapping->{controller}, "admin";
    is $mapping->{action}, "show";
    is $mapping->{id}, "123";
}
else {
    fail "Not maching" for 1..3;
}
