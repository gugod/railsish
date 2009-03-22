package Railsish::TextHelpers;
use strict;
use warnings;
use Exporter::Lite;

our @EXPORT = qw(pluralize singularize);

use Lingua::EN::Inflect::Number qw(to_S to_PL);

sub pluralize { &to_PL }
sub singularize { &to_S }


1;

