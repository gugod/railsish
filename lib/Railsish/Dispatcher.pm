package Railsish::Dispatcher;
# ABSTRACT: The first handler for requests.

use Mouse;
use Railsish::Router;
use YAML::Any;
use Hash::Merge qw(merge);
use Encode;

sub dispatch {
    my ($class, $request) = @_;
    my $path = $request->path;

    $path =~ s/\.([a-z]+)$//;
    my $format = $1 || "html";

    my $method = lc($request->method);
    my $matched = Railsish::Router->match(
        $path, conditions => { method => $method }
    );

    my $response = HTTP::Engine::Response->new;
    unless($matched) {
        $response->body("internal server error");
        $response->status(500);
        return $response;
    }

    my $mapping = $matched->mapping;

    my $controller = $mapping->{controller};
    my $action = $mapping->{action} || "index";

    my $controller_class = ucfirst(lc($controller)) . "Controller";
    my $sub = $controller_class->can($action);

    die "action $action is not defined in $controller_class." unless $sub;
    my %params = %{$request->parameters};
    for (keys %params) {
        $params{$_} = Encode::decode_utf8( $params{$_} );
    }

    my $params = merge(\%params, $mapping);

    $Railsish::Controller::params = $params;
    $Railsish::Controller::request = $request;
    $Railsish::Controller::response = $response;
    $Railsish::Controller::controller = $controller;
    $Railsish::Controller::action = $action;
    $Railsish::Controller::format = $format;

    $sub->();

    return $response;

}

__PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

This class contains the first handler for requests.

=cut
