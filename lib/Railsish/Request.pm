package Railsish::Request;
use Mouse;

extends 'HTTP::Engine::Request';

__PACKAGE__->meta->make_immutable;
