#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Railsish::Router;

Railsish::Router->draw(
    sub {
        my ($map) = @_;

        $map->login("/login");
    }
);

is(Railsish::Router->login_path, "/login");
