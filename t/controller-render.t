#!/usr/bin/env perl -w
use strict;
use Test::More tests => 4;

use lib qw(lib t/SimpleApp);

package FooController;
use Railsish::Controller;

package main;

ok(FooController->can("render"));
ok(FooController->can('render_xml'));
ok(FooController->can("render_json"));

ok(FooController->can("redirect_to"));


