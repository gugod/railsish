#!/usr/bin/env perl -w
use strict;
use warnings;

use Test::More tests => 1;;

package PostsController;
use Railsish::Controller;
use Test::More;

sub index {
    response->body("index is rendered");
}

sub show {
    my $id = params("id");
    response->body("post($id) is rendered");
}

package main;
use Railsish::Router;

Railsish::Router->draw(
    sub {
        my ($map) = @_;
	$map->resources("posts")
    }
);

use Railsish::Dispatcher;
use HTTP::Engine;

use HTTP::Request;

my $engine = HTTP::Engine->new(
    interface => {
        module => "Test",
        request_handler => sub {
            Railsish::Dispatcher->dispatch(@_);
        }
    }
);

my $response = $engine->run(
    HTTP::Request->new(GET => "http://localhost/posts")
);

is($response->content, "index is rendered");
