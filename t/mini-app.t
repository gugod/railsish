#!/usr/bin/env perl -w
use strict;
use warnings;

use Test::More tests => 1;;

package FooController;
use Railsish::Controller;
use Test::More;

sub bar {
    is(params("id"), "baz");
}

package main;
use HTTP::Engine::Request;
use HTTP::Engine::RequestBuilder::NoEnv;

use IO::String;

use Railsish::Router;
use Railsish::Dispatcher;

Railsish::Router->draw(
    sub {
        my ($map) = @_;
        $map->connect("/:controller/:action/:id")
    }
);

my $in = IO::String->new;
my $out = IO::String->new;

my $request = HTTP::Engine::Request->new(
    request_builder => "HTTP::Engine::RequestBuilder::NoEnv",
    uri => "/foo/bar/baz",
    headers => {},
    _connection => {
        input_handle => $in,
        output_handle => $out,
    },
);

Railsish::Dispatcher->dispatch($request);
