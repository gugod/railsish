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
    my $matched = Railsish::Router->match($path);

    die "No routing rule for $path" unless $matched;

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

    my $response = HTTP::Engine::Response->new;

    $Railsish::Controller::params = $params;
    $Railsish::Controller::request = $request;
    $Railsish::Controller::response = $response;
    $Railsish::Controller::controller = $controller;
    $Railsish::Controller::action = $action;

    $sub->();

    return $response;

}

__PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

This class contains the first handler for requests.

=cut
