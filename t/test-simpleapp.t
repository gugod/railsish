#!/usr/bin/env perl -w
use strict;
use Cwd;

BEGIN {
    my $cwd = getcwd;
    unshift @INC, "$cwd/t/lib";
    unshift @INC, "$cwd/t/SimpleApp/lib";
}

use HTTP::Engine;
use HTTP::Request;
use Test::More tests => 1;
use SimpleApp;

chdir("t/SimpleApp");
use lib '../../lib';

$ENV{APP_ROOT} = getcwd;

my $engine = HTTP::Engine->new(
    interface => {
	module => 'Test',
	request_handler => \&SimpleApp::handle_request
    }
);

my $response = $engine->run(
    HTTP::Request->new(GET => 'http://localhost/welcome/here'),
    env => \%ENV,
    connection_info => {
	request_uri => "/welcome/here"
    }
);

like $response->content, qr{<p>The answer is 42</p>};
