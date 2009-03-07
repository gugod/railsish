package Railsish::Router;
use Moose;

use Path::Router;

has "router" => (
    is => "rw",
    isa => "Path::Router",
    lazy_build => 1,
);

sub _build_router {
    my ($self) = @_;
    return Path::Router->new;
}

sub connect {
    my ($self, $urlish, @vars) = @_;

    $self->router->add_route(
	$urlish => (
	    defaults => { @vars }
	)
    );
}

sub uri_for {
    my $self = shift;
    $self->router->uri_for(@_);
}


__PACKAGE__->meta->make_immutable;

1;
