#!/usr/bin/env perl

use strict;
use warnings;
use Railsish::Database;
use Railsish::Record;

{
    no strict;
    no warnings;
    *Railsish::Database::_build_config = sub {
	return {
	    dsn => "hash",
	    user => "",
	    password => ""
	};
    }
}

package Advertisement;
use Moose;
use MooseX::Types::DateTimeX qw(DateTime);

extends 'Railsish::Record';

has type  => ( isa => "Str", is => "ro", required => 1);
has url   => ( isa => "Str", is => "rw", required => 1);
has title => ( isa => "Str", is => "rw", required => 1);

has start_date => ( isa => DateTime, is => "rw", required => 1, coerce => 1 );
has end_date   => ( isa => DateTime, is => "rw", required => 1, coerce => 1 );

package main;
use Test::More tests => 1;

my $obj = Advertisement->new(
    type => "normal",
    url => "http://example.com",
    title => "Example",
    start_date => "2009-05-08",
    end_date => "2009-010-08"
);

my @titles = ();
$obj->save;
my $stream = Advertisement->find_all;
while (my $block = $stream->next) {
    for my $obj (@$block) {
	push @titles, $obj->title;
    }
}

is_deeply(\@titles, ["Example"]);
