package Railsish::Helpers;

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

