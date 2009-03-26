package Railsish::PathHelpers;
use strict;
use warnings;
our @HELPERS = ();

sub install_helpers {
    my $to = caller;
    for(@HELPERS) {
	no strict;
	*{$to . "::" . $_} = *{__PACKAGE__ . "::" . $_};
    }
}

1;
