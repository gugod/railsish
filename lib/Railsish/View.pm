package Railsish::View;
use Moose;
use Template;

has template_root => (
    is => "ro",
    isa => "Str",
    required => 1
);

use Railsish::ViewHelpers ();

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

__PACKAGE__->meta->make_immutable;

1;

=head1 SYNOPSIS

    # Explicit
    Railsish::View->render(template => "foo/bar.html.tt2", %vars);

    # Smart
    Railsish::View->render("foo/bar", %vars);

=head1 DESCRIPTION


=cut
