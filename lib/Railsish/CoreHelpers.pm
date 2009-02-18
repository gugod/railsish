package Railsish::CoreHelpers;
# ABSTRACT: Things that you'll need in about everywhere.

use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(app_root);

use File::Spec::Functions;
    
sub app_root {
    catfile($ENV{APP_ROOT}, @_)
}

1;
