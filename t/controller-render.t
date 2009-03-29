#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use lib qw(lib t/SimpleApp);

package FooController;
use Railsish::Controller;

package main;

ok(FooController->can('render_xml'));


