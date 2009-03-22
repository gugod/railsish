#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 4;

use Railsish::TextHelpers;

is( pluralize("photo"), "photos");
is( pluralize("photos"), "photos");
is( singularize("photo"), "photo");
is( singularize("photos"), "photo");
