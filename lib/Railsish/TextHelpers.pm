package Railsish::TextHelpers;
use strict;
use warnings;
use Exporter::Lite;

our @EXPORT = qw( pluralize singularize camelize camelcase underscore dasherize forien_key );

use Lingua::EN::Inflect::Number qw(to_S to_PL);

sub pluralize { &to_PL }
sub singularize { &to_S }

use String::CamelCase qw(camelize decamelize);

sub camelcase { &camelize }
sub underscore { &decamelize }

sub dasherize {
  my $str = &decamelize;
  $str =~ s/_/-/g;
  return $str;
}

sub forien_key {
  my $str = &decamelize;
  $str =~ s/(?!_id)$/_id/;
  return $str;
}

1;

