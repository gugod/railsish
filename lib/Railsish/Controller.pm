package Railsish::Controller;
use strict;
use warnings;

my ($request, $response, $controller, $action, $format);

sub request() { $request }
sub response() { $response }
sub controller() { $controller }
sub action() { $action }
sub format() { $format }
sub app_root { $ENV{APP_ROOT} }

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
use Binding;

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

    my $caller_vars = Binding->of_caller->our_vars;

    for my $varname (keys %$caller_vars) {
        my $val = $caller_vars->{$varname};
        $varname =~ s/^[\$%@]//;
        $val = $$val if ref($val) eq 'SCALAR';
        $variables{$varname} = $val;
    }

    $variables{title} ||= ucfirst($controller) . " :: " .ucfirst($action);
    $variables{controller} = \&controller;
    $variables{action} = \&action;

    my $tt = Template->new({
        INCLUDE_PATH => [ catdir(app_root, "app", "views") ],
        PROCESS => "layout/application.html.tt2",
        ENCODING => 'utf8'
    });

    my $output = "";
    $tt->process((delete $variables{template} || "${controller}/${action}.html.tt2"), \%variables, \$output);

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
