package Railsish::Bootstrap;
# ABSTRACT: Wuu huu huu

use strict;
use warnings;
use Railsish::CoreHelpers;
use File::Spec::Functions;
use Railsish::Router;

sub import {
    my @dir = map { catdir(app_root, "app", $_ ) } qw(controllers helpers models);
    unshift @INC, @dir;
}

sub load_configs {
    my $routes = app_root(config => "routes.pl");
    require $routes or die "Failed to load $routes";
}

use Module::Loaded;
use Class::Implant;

sub load_controllers {
    my $app_root = app_root;

    my @controllers = glob("${app_root}/app/controllers/*.pm");

    logger->debug("Loading controllers: ${app_root}/app/controllers/*.pm");

    for(@controllers) {
	require $_ or die "Failed to load $_\n";
        my $helper = $_;
        my $controller_package = $_;

        $controller_package =~ s/.*\/(\w+).pm/$1/;
        $helper =~ s/controllers/helpers/;
        $helper =~ s/Controller/Helpers/;

        logger->debug(" - $controller_package loaded");

        if (-f $helper) {
            require $helper or die "Failed to load $helper\n";

            my $helper_package = $helper;
            $helper_package =~ s/.*\/(\w+).pm/$1/;

            implant $helper_package, { into => $controller_package };

            logger->debug("   - $helper_package loaded");
        }
    }
}

sub load_helpers {
    my $app_root = app_root;
    my @helpers = glob("${app_root}/app/helpers/*.pm");
    for (@helpers) {
        require $_ or die "Failed to load $_, $!\n";
        warn " - (load_heplers) $_ loaded\n";
    }
}

1;

=head1 DESCRIPTION

This class reads application configurations.

=cut

