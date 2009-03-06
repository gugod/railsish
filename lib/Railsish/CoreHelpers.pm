package Railsish::CoreHelpers;
# ABSTRACT: Things that you'll need in about everywhere.

use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(app_root logger);

use Log::Dispatch;
use Log::Dispatch::File;

use File::Spec::Functions;
    
sub app_root {
    catfile($ENV{APP_ROOT}, @_)
}

{
    my $file = app_root(log => "debug.log");
    my $logger = Log::Dispatch->new;
    $logger->add(
	Log::Dispatch::File->new(name => "debug", min_level => "debug", filename => $file)
    );

    sub logger { $logger }
}

1;
