package Railsish::Dispatcher;
# ABSTRACT: The first handler for requests.

use Mouse;
use Railsish::Router;

sub dispatch {
    my ($class, $request) = @_;

    my $matched = Railsish::Router->match($request->path);
    my $mapping = $matched->mapping;

    my $c = $mapping->{controller};
    my $a = $mapping->{action};

    $c = ucfirst(lc($c)) . "Controller";
    my $sub = $c->can($a);

    die "action $a is not defined in $c." unless $sub;
    my $params = $request->query_parameters;

    for (keys %$mapping) {
        $params->{$_} = $mapping->{$_} unless defined $params->{$_};
    }

    $Railsish::Controller::params = $params;
    $sub->();

}

no Mouse;
1;

=head1 DESCRIPTION

This class contains the first handler for requests.

=cut

