#!/usr/bin/env perl -w
use strict;
use Test::More tests => 9;

use Railsish::Router;

Railsish::Router->draw(
    sub {
        my ($map) = @_;

        $map->resources("photos");
    }
);

my $m;

$m = Railsish::Router->match("/photos/3")->mapping;
is($m->{controller}, "photos");
is($m->{action}, "show");
is($m->{id}, 3);

$m = Railsish::Router->match("/photos")->mapping;
is($m->{controller}, "photos");
is($m->{action}, "index");
is($m->{id}, undef);

$m = Railsish::Router->match("/photos/3/edit")->mapping;
is($m->{controller}, "photos");
is($m->{action}, "edit");
is($m->{id}, 3);
