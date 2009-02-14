package Railsish::Helpers;
# ABSTRACT: the base class of helper classes

sub import {
    my ($class) = shift;
    my $caller = caller;
    require Devel::Symdump;
    my $ds = Devel::Symdump->new($class);

    no strict;
    for my $f ($ds->functions) {
        my $name = $f;
        $name =~ s/^.*:://;
        *{"$caller\::$name"} = $f;
    }
}

1;


=head1 SYNOPSIS

Your helper classes should always use this module:

    package MyApp::BlogHelpers;
    use Railsish::Helpers;

    # auto-export *all* functions defined in under package.

=head1 DESCRIPTION

This is the helpr class that automatically export B<all> functions in
the package that use it. It is designed to work with helper (those
named liked MyApp::FooHelpers)

=cut
