package Railsish::Database;
# ABSTRACT: Talks to database

use Moose;
use KiokuDB;
use Railsish::CoreHelpers;
use YAML::Any qw(LoadFile);

has 'config' => (
    is  => "ro",
    isa => "HashRef",
    lazy_build => 1,
    required => 1
);

has 'dsn' => (
    isa => "Str",
    is  => "rw",
    lazy_build => 1
);

has 'kioku' => (
    is => "ro",
    lazy_build => 1
);

sub _build_config {
    my $self = shift;
    my $file = app_root(config => "database.yml");

    die "config/database.yml does not exist\n"
	unless -f $file;

    return LoadFile($file);
}

sub _build_dsn {
    my $self = shift;
    my $dsn = $ENV{SUDA_TEST_DSN} ||
	$self->config->{development}{dsn};
    return $dsn;
}

sub _build_kioku {
    my $self = shift;
    return KiokuDB->connect($self->dsn, create => 1);
}

__PACKAGE__->meta->make_immutable;

1;
