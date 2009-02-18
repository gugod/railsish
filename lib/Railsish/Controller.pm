package Railsish::Controller;
# ABSTRACT: base class for webapp controllers.
use strict;
use warnings;

use Railsish::CoreHelpers;

my ($request, $response, $controller, $action, $format);

sub request() { $request }
sub response() { $response }
sub controller() { $controller }
sub action() { $action }
sub format() { $format }

sub import {
    my $class = shift;
    my $caller = caller;
    no strict;

    push @{"$caller\::ISA"}, $class;

    *{"$caller\::request"}    = \&request;
    *{"$caller\::response"}   = \&response;
    *{"$caller\::controller"} = \&controller;
    *{"$caller\::action"}     = \&action;
    *{"$caller\::format"}     = \&format;
    *{"$caller\::render"}     = \&render;
}

sub dispatch {
    (my $self, $request, $response) = @_;

    my $path    = $request->request_uri;
    ($format)   = $path =~ /\.(....?)$/;
    my @args    = split "/", $path; shift @args; # discard the first undef
    $controller = shift @args || 'welcome';
    $action     = shift @args || 'index';

    if ($self->can($action)) {
        $self->$action(@args);
    }

    return $response;
}

use Template;
use File::Spec::Functions;
use Binding 0.04;
use Perl6::Junction qw(any);

sub build_stash {
    my $caller_vars = Binding->of_caller(2)->our_vars;
    my $stash = {};
    for my $varname (keys %$caller_vars) {
        my $val = $caller_vars->{$varname};
        $varname =~ s/^[\$%@]//;
        $val = $$val if ref($val) eq any('SCALAR', 'REF');
	$stash->{$varname} = $val;
    }
    return $stash;
}

sub render {
    my (%variables) = @_;

    if (defined($format)) {
        my $renderer = __PACKAGE__->can("render_${format}");
        if ($renderer) {
            $renderer->(%variables);
            return;
        }
        $response->status(500);
        $response->body("Unknown format: $format");
    }

    my $stash = build_stash;

    for (keys %$stash) {
	$variables{$_} = $stash->{$_};
    }

    $variables{controller} = \&controller;
    $variables{action}	   = \&action;

    $variables{title}    ||= ucfirst($controller) . " :: " .ucfirst($action);
    $variables{layout}   ||= "layouts/application.html.tt2";
    $variables{template} ||= "${controller}/${action}.html.tt2";

    my $tt = Template->new({
        INCLUDE_PATH => [ catdir(app_root, "app", "views") ],
        PROCESS => $variables{layout},
        ENCODING => 'utf8'
    });

    my $output = "";
    $tt->process($variables{template}, \%variables, \$output)
	|| die $tt->error();
    $response->body($output);
}


use JSON;
sub render_json {
    my %variables = @_;

    my $out = to_json(\%variables);

    $response->headers->header('Content-Type' => 'text/x-json');
    $response->body($out);
}

# Provide a default 'index'
sub index {
    render;
}


1;
