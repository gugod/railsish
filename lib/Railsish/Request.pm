package Railsish::Request;
use Any::Moose;

extends 'HTTP::Engine::Request';

__PACKAGE__->meta->make_immutable;
