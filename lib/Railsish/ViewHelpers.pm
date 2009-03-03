package Railsish::ViewHelpers;
use strict;
use warnings;
use Railsish::CoreHelpers;

sub stylesheet_link_tag {
    my (@css) = @_;

    my $out = "";
    for my $css (@css) {
	my $uri;
	if ($css =~ /^http:/) {
	    $uri = $css;
	}
	else {
	    my $dir = app_root("/public/stylesheets");

	    my $file = "${dir}/${css}.css";
	    $file = "${dir}/${css}" unless -f $file;
	    $file .= "?" . (stat($file))[9];
	    $uri = $file;
	    $uri =~ s/^$dir/\/stylesheets/;
	}

	if ($uri) {
            $out .= qq{<link href="$uri" media="all" rel="stylesheet" type="text/css">\n}
	}
    }
    return $out;
};

1;
