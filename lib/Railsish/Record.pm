package Railsish::Record;
use Any::Moose;
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

sub destroy {
    my ($self) = @_;
    db->delete($self);
}

use JSON;
sub TO_JSON {
    my ($self) = @_;
    my $h = {};
    for my $attr ( $self->meta->get_all_attributes ) {
        my $n = $attr->{name};
        $h->{$attr->name} = "" . $self->$n;
    }
    return $h;
}

__PACKAGE__->meta->make_immutable;

