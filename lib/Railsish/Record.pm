package Railsish::Record;
use Mouse;
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

sub find {
    my ($self, $id) = @_;
    db->lookup($id);
}

sub find_all {
    my ($self, @args) = @_;
    db->search(CLASS => (ref($self) || $self), @args);
}

sub id {
    my ($self) = @_;
    return db->object_to_id($self);
}

sub save {
    my ($self) = @_;
    db->store($self);
}

sub delete {
    my ($self) = @_;
    db->delete($self);
}

__PACKAGE__->meta->make_immutable;
