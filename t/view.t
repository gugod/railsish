#!/usr/bin/env perl -w
use strict;
use Test::More tests => 2;
use FindBin qw($Bin);

use Railsish::View;

my $view = Railsish::View->new(
    template_root => "$Bin/app2/app/views"
);


{
    my $html = $view->render("welcome/index");
    like $html, qr/Welcome/;
}

{
    my $html = $view->render(file => "welcome/index.html.tt2");
    like $html, qr/Welcome/;
}
