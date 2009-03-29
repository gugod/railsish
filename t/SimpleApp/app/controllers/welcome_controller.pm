package WelcomeController;
use Railsish::Controller;

sub index {
    render(title => "Welcome");
}

sub here {
    our $answer = 42;
    render;
}


1;
