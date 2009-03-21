#!/usr/bin/env perl -w
use strict;
use Test::More tests => 3;

use Railsish::Router;

Railsish::Router->draw(
    sub {
        my ($map) = @_;

        $map->login("/login", controller => "login");
        $map->user("/users/:id", controller => "users", action => "show");
    }
);

is(Railsish::Router->login_path, "/login", "urlish with variables");
is(Railsish::Router->user_path(id => 3), "/users/3", "urlish with variables");
is(Railsish::Router->uri_for(controller => "users", action => "show", id => 3), "/users/3", "retrivie the uri with using names");

