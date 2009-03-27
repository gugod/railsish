package Railsish::Bootstrap;
# ABSTRACT: Wuu huu huu

use strict;
use warnings;
use Railsish::CoreHelpers;
use File::Spec::Functions;
use Railsish::Router;

sub import {
    unshift @INC, catdir(app_root, "app", "controllers");
}

sub load_configs {
    my $routes = app_root(config => "routes.pl");
    require $routes or die "Failed to load $routes";
}

sub load_controllers {
    my $app_root = app_root;
    my @controllers = glob("\Q${app_root}\E/app/controllers/*.pm");
    for(@controllers) {
	require $_ or die "Failed to load $_\n";
    }
}

1;

=head1 DESCRIPTION

This class reads application configurations.

=cut

