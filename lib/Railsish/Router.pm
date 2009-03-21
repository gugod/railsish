package Railsish::Router;
use Mouse;

use Path::Router;

has "routers" => (
    is => "rw",
    isa => "HashRef[Path::Router]",
    lazy_build => 1,
);

sub _build_routers {
    return {
        get    => Path::Router->new,
        post   => Path::Router->new,
        put    => Path::Router->new,
        delete => Path::Router->new
    }
}

my $APP_ROUTER;

sub connect {
    my ($self, $urlish, %vars) = @_;
    $self = $APP_ROUTER unless ref($self);

    my $routers = $self->routers;

    if (my $conditions = delete $vars{conditions}) {
        my $method = lc($conditions->{method});
        $routers->{$method}->add_route($urlish => (defaults => \%vars));
    }
    else {
        for(qw(get post put delete)) {
            $routers->{$_}->add_route($urlish => (defaults => \%vars));
        }
    }

}
use YAML;
sub match {
    my ($self, $uri, %args) = @_;
    $self = $APP_ROUTER unless ref($self);

    my $routers = $self->routers;
    my $conditions = $args{conditions};
    if ($conditions) {
        my $method = lc($conditions->{method});
        return $routers->{$method}->match($uri);
    }
    else {
        for(qw(get post put delete)) {
            if (my $matched = $routers->{$_}->match($uri)) {
                return $matched;
            }
        }
    }
}

sub uri_for {
    my ($self, @args) = @_;
    $self = $APP_ROUTER unless ref($self);

    my $routers = $self->routers;
    for (qw(get post put delete)) {
        if (my $url = $routers->{$_}->uri_for(@args)) {
            return $url;
        }
    }
}

# this one should be invoked like: Railsish::Router->draw;
sub draw {
    my ($class, $cb) = @_;
    $APP_ROUTER = $class->new;
    $cb->($APP_ROUTER);

    return $APP_ROUTER;
}

use Sub::Install;

our $AUTOLOAD;
sub AUTOLOAD {
    my ($self, $uri) = @_;
    $self = $APP_ROUTER unless ref($self);

    my $name = $AUTOLOAD;
    $name =~ s/^.*:://;

    Sub::Install::install_sub({
        into => __PACKAGE__,
        code => sub { return $uri },
        as => "${name}_path"
    });
}

__PACKAGE__->meta->make_immutable;
