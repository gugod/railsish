package Railsish::Router;
use Mouse;

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

my $APP_ROUTER;

sub connect {
    my ($self, $urlish, @vars) = @_;
    $self = $APP_ROUTER unless ref($self);

    $self->router->add_route(
	$urlish => (
	    defaults => { @vars }
	)
    );
}

sub match {
    my ($self, $uri) = @_;
    $self = $APP_ROUTER unless ref($self);

    $self->router->match($uri)
}

sub uri_for {
    my $self = shift;
    $self = $APP_ROUTER unless ref($self);

    $self->router->uri_for(@_);
}

# this one should be invoked like: Railsish::Router->draw;
sub draw {
    my ($class, $cb) = @_;
    $APP_ROUTER = $class->new;
    $cb->($APP_ROUTER);

    return $APP_ROUTER;
}

no Mouse;

1;
