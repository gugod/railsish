package Railsish::ControllerHelpers;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(notice_stickie);

sub notice_stickie {
    my ($text) = @_;
    my $session = $Railsish::Controller::session;
    push @{$session->{notice_stickies}}, { text => $text };
}

1;
