package Railsish::View;
use Moose;

has template_root => (
    is => "ro",
    isa => "Str",
    required => 1
);

use Railsish::ViewHelpers ();
require UNIVERSAL::require;

sub render {
    my ($self, %vars) = @_;

    unless ( $vars{template} =~ m/\.(\w+)$/ ) {
	die "Don't know how to render $vars{template}\n";
    }
    my $view_class = "Railsish::View::$1";
    $view_class->require or die $@;
    
    my $view_obj = $view_class->new(
	template_root => $self->template_root
    );

    my $output = $view_obj->render(%vars);

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
