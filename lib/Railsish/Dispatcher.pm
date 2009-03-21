package Railsish::Dispatcher;
# ABSTRACT: The first handler for requests.

use Mouse;
use Railsish::Router;
use YAML::Any;
use Hash::Merge qw(merge);

sub dispatch {
    my ($class, $request) = @_;
    my $path = $request->path;
    my $matched = Railsish::Router->match($path);

    die "No routing rule for $path" unless $matched;

    my $mapping = $matched->mapping;

    my $c = $mapping->{controller};
    my $a = $mapping->{action} || "index";

    $c = ucfirst(lc($c)) . "Controller";
    my $sub = $c->can($a);

    die "action $a is not defined in $c." unless $sub;
    my %params = %{$request->query_parameters};

    my $params = merge($request->parameters, $mapping);

    my $response = HTTP::Engine::Response->new;

    $Railsish::Controller::params = $params;
    $Railsish::Controller::request = $request;
    $Railsish::Controller::response = $response;

    $sub->();

    return $response;

}

__PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

This class contains the first handler for requests.

=cut
