package Railsish::Controller;
# ABSTRACT: base class for webapp controllers.
use strict;
use warnings;

use Railsish::CoreHelpers;
use Railsish::ViewHelpers ();
use Railsish::ControllerHelpers ();
use Encode;
use YAML qw(Dump);

our ($request, $response, $controller, $action, $format, $params);

sub request() { $request }
sub response() { $response }
sub controller() { $controller }
sub action() { $action }
sub format() { $format }

sub params {
    my $name = shift;
    return defined($name) ? $params->{$name} : $params;
}

sub import {
    my $class = shift;
    my $caller = caller;
    no strict;

    push @{"$caller\::ISA"}, $class;

    *{"$caller\::request"}     = \&request;
    *{"$caller\::response"}    = \&response;
    *{"$caller\::controller"}  = \&controller;
    *{"$caller\::action"}      = \&action;
    *{"$caller\::format"}      = \&format;
    *{"$caller\::params"}      = \&params;
    *{"$caller\::render"}      = \&render;
    *{"$caller\::render_json"} = \&render_json;
    *{"$caller\::render_xml"}  = \&render_xml;
    *{"$caller\::redirect_to"} = \&redirect_to;

    for (@Railsish::ControllerHelpers::EXPORT) {
        *{"$caller\::$_"} = *{"Railsish::ControllerHelpers::$_"};
    }
}

use Template;
use File::Spec::Functions;
use Binding 0.04;
use Perl6::Junction qw(any);
use Railsish::PathHelpers ();

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
    my $stash = build_stash;

    for (keys %$stash) {
	$variables{$_} = $stash->{$_};
    }

    if (defined($format)) {
        my $renderer = __PACKAGE__->can("render_${format}");
        if ($renderer) {
            $renderer->(%variables);
            return;
        }
        $response->status(500);
        $response->body("Unknown format: $format");
    }

    $variables{controller} = \&controller;
    $variables{action}	   = \&action;

    for (@Railsish::ViewHelpers::EXPORT) {
	$variables{$_} = \&{"Railsish::ViewHelpers::$_"};
    }

    my $path_helpers = Railsish::PathHelpers->as_hash;
    for (keys %$path_helpers) {
	$variables{$_} = $path_helpers->{$_}
    }

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

    $response->body(Encode::encode_utf8($output));
}


use JSON -convert_blessed_universally;
sub render_json {
    my %variables = @_;

    my $json = JSON->new;
    $json->allow_blessed(1);

    my $out = $json->encode(\%variables);

    $response->headers->header('Content-Type' => 'text/x-json');
    $response->body( Encode::encode_utf8($out) );
}

use XML::Simple;
sub render_xml {
    # still not write testing

    my %variables = @_;

    my $out = XMLout(\%variables);

    $response->header->header("Content-Type" => "text/xml");
    $response->body( Encode::encode_utf8($out) );
}

use Railsish::TextHelpers;

sub redirect_to {
    my @args = @_;
    my $url;
    my $current_controller = caller;

    $current_controller = underscore($current_controller);
    $current_controller =~ s/_controller$//;

    if (@args == 1) {
        $url = $args[0];
    }
    elsif (@args % 2 == 0) {
        my %args = (@args);
        $args{controller} ||= $current_controller;
        $url = Railsish::Router->uri_for(%args);
    }
    else {
        die("Unknown redirect_to parameters: @args");
    }
    $response->status(302);
    $response->header(Location => $url);
}

# Provide a default 'index'
sub index {
    render;
}


1;
