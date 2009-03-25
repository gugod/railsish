package Railsish::Bootstrap;
# ABSTRACT: Wuu huu huu

use strict;
use warnings;
use Railsish::CoreHelpers;
use File::Spec::Functions;

sub import {
    unshift @INC, catdir(app_root, "app", "controllers");
}

sub read_config_route {
    # XXX: is it to oldie to use .pl for config :-)
    my $config = app_root(config => "route.pl");
}

sub load_controllers {
    my $app_root = app_root;
    my @controllers = glob("\Q${app_root}\E/app/controllers/*Controller.pm");
    for(@controllers) {
	warn $_ . "\n";
	require $_;
    }
}

1;

=head1 DESCRIPTION

This class reads application configurations.

=cut

