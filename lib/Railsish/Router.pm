package Railsish::Router;
use Mouse;

use Path::Router;

has "routers" => (
    is => "rw",
    isa => "HashRef[Path::Router]",
    lazy_build => 1,
);

has named_paths => (
    is => "rw",
    isa => "HashRef",
    default => sub {{}}
);

sub _build_routers {
    return {
        _named => Path::Router->new,
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
    my @routes;
    if (my $conditions = delete $vars{conditions}) {
        my $method = lc($conditions->{method});
        push @routes, $routers->{$method}->add_route($urlish => (defaults => \%vars));
    }
    else {
        for(qw(get post put delete)) {
            push @routes, $routers->{$_}->add_route($urlish => (defaults => \%vars));
        }
    }
    return @routes;
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
        for(qw(_named get post put delete)) {
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
    for (qw(_named get post put delete)) {
        if (my $url = $routers->{$_}->uri_for(@args)) {
            return "/$url";
        }
    }
}

use Lingua::EN::Inflect qw(PL_N);

sub resources {
    my ($self, $name) = @_;
    $self = $APP_ROUTER unless ref($self);

    $name =~ s/s$//;

    my $resource  = PL_N($name, 1);
    my $resources = PL_N($name, 42);

    $self->$resources("/$resources", controller => $resources, action => "index");
    $self->$resource("/$resources/:id", controller => $resources, action => "show");

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
    my ($self, $urlish, %vars) = @_;
    $self = $APP_ROUTER unless ref($self);

    my $name = $AUTOLOAD;
    $name =~ s/^.*:://;

    $self->routers->{_named}->add_route($urlish => (defaults => \%vars));

    Sub::Install::install_sub({
        into => __PACKAGE__,
        code => sub {
            my ($self, @args) = @_;
            $self = $APP_ROUTER unless ref($self);

            return "/" . $self->routers->{_named}->uri_for(@args);
        },
        as => "${name}_path"
    });
}

__PACKAGE__->meta->make_immutable;
