package Railsish;
# ABSTRACT: A web application framework.

use strict;
use warnings;

use HTTP::Engine::Response;
use UNIVERSAL::require;

my $app_package;

sub import {
    $app_package = caller;

    no strict;
    for (qw(handle_request)) {
        *{"$app_package\::$_"} = \&$_;
    }
}

1;

=head1 DESCRIPTION

This is a web app framework that is still very experimental.

=head1 EXAMPLE

At this moment, see t/SimpleApp for how to use this web framework.

=cut

