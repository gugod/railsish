package Railsish::ModPerl;
use Moose;
extends 'HTTP::Engine::Interface::ModPerl';

use Railsish::Bootstrap;
Railsish::Bootstrap->load_controllers;
Railsish::Bootstrap->load_configs;

use Railsish::Dispatcher;
use HTTP::Engine;

sub create_engine {
    my($class, $r, $context_key) = @_;

    HTTP::Engine->new(
        interface => {
            module => "ModPerl",
            request_handler => sub {
                my ($request) = @_;
                warn $request->method . " " . $request->path . "\n";
                Railsish::Dispatcher->dispatch(@_);
            }
        }
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
