#!/usr/bin/env perl -w
use strict;
use Test::More tests => 3;

use Railsish::Router;

Railsish::Router->draw(
    sub {
        my ($map) = @_;

        $map->resources("photos");
    }
);


my $m = Railsish::Router->match("/photos/3")->mapping;
is($m->{controller}, "photos");
is($m->{action}, "show");
is($m->{id}, 3);
