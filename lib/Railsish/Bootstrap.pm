package Railsish::Bootstrap;
# ABSTRACT: Wuu huu huu

use strict;
use warnings;
use Railsish::CoreHelpers;

sub read_config_route {
    # XXX: is it to oldie to use .pl for config :-)
    my $config = app_root(config => "route.pl");
}

1;

=head1 DESCRIPTION

This class reads application configurations.

=cut

