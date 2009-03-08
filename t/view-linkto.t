#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Railsish::ViewHelpers;

my $html = Railsish::ViewHelpers::link_to("Dashboard", "/dashboard", class => "nav");

is($html, qq{<a href="/dashboard" class="nav">Dashboard</a>});
