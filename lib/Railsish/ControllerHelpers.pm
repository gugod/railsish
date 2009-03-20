package Railsish::ControllerHelpers;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(notice_stickie);

our @notice_stickies = ();

sub notice_stickie {
    my ($text) = @_;

    push @notice_stickies, { text => $text };
}

1;
