#!/usr/bin/env perl -w
use strict;
use warnings;
use Test::More;

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

sub new {
    response->body("new_post is rendered")
}

sub edit {
    response->body("edit_post(@{[ params('id') ]}) is rendered")
}

sub create {
    response->body("create_post is rendered");
}

sub update {
    response->body("update_post(@{[ params('id') ]}) is rendered");
}

sub destroy {
    response->body("destroy_post(@{[ params('id') ]}) is rendered");
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

my @reqs = (
    [GET  => "/posts", "index is rendered"],
    [GET  => "/posts/3", "post(3) is rendered"],
    [GET  => "/posts/new", "new_post is rendered"],
    [GET  => "/posts/3/edit", "edit_post(3) is rendered"],

    [POST => "/posts", undef, "xxx", "create_post is rendered"],
    [PUT  => "/posts/3", undef, 'yyy', "update_post(3) is rendered"],

    [DELETE => "/posts/3", "destroy_post(3) is rendered"],
);

plan tests => 0+@reqs;

for (@reqs) {
    my $response_content = pop(@$_);
    my $response = $engine->run(HTTP::Request->new(@$_));
    is($response->content, $response_content);
}

