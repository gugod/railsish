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

use Railsish::Logger;
{
    my $logger;
    sub logger {
	return $logger if defined($logger);
	$logger = Railsish::Logger->new;
	return $logger;
    }
}

1;
