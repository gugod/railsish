package Railsish::Record;
use Moose;
use DateTime;

use Railsish::Database;

has created_at => (
    isa => "DateTime",
    is => "ro",
    default => sub { DateTime->now }
);

{
    my $db;
    sub db {
	return $db if defined $db;
	$db = Railsish::Database->new;
    }
}

sub find_all {
    my ($self, @args) = @_;
    db->search(CLASS => (ref($self) || $self), @args);
}

sub save {
    my ($self) = @_;
    db->store($self);
}


__PACKAGE__->meta->make_immutable;

1;
