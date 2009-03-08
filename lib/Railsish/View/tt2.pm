package Railsish::View::tt2;

use Moose;
extends 'Railsish::View';

use Template;

sub render {
    my ($self, %vars) = @_;

    $vars{layout} ||= "layouts/application.html.tt2";

    my $tt = Template->new({
        INCLUDE_PATH => [ $self->template_root ],
        PROCESS => $vars{layout},
        ENCODING => 'utf8'
    });

    for (@Railsish::ViewHelpers::EXPORT) {
	$vars{$_} = \&{"Railsish::ViewHelpers::$_"};
    }

    my $output = "";
    $tt->process($vars{template}, \%vars, \$output)
	|| die $tt->error();

    return $output;
}

1;
