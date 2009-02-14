package SimpleApp::WelcomeController;
use strict;
use warnings;

use Railsish::Controller;

sub index {
    render(title => "Welcome");
}

sub here {
    our $answer = 42;
    render;
}

1;

