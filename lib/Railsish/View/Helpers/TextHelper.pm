package Railsish::View::Helpers::TextHelper;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(pluralize);



use Lingua::EN::Inflect qw(PL);

sub pluralize {
    my ($count, $singular, $plural) = @_;

    return $singular if $count == 1;
    return $plural if defined $plural;
    return PL($singular)
}

1;
