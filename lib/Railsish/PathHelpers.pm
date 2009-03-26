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

sub hash_for_helpers {
    my $ret = {};
    for (@HELPERS) {
	no strict;
	$ret->{$_} = \&{__PACKAGE__ . "::" . $_};
    }
    return $ret;
}

1;
