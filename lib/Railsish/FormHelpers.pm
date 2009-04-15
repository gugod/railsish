package Railsish::FormHelpers;
# ABSTRACT: Using for generate tags related to form in application view

use strict;
use warnings;

sub form_tag ($;@&) {
  my $code = ( ref($_[-1]) eq "CODE" ? pop(@_) : undef );
  my ($target, %options) = @_;

  my $result = "<form action=\"$target\">" ;

  for (keys %options) {
    $result =~ s/>$/ $_=\"$options{$_}\"\>/
  }

  $result .= $code->() if defined($code);
  $result .= '</form>';
  $result;
}

sub submit_tag {
  return "<input type=\"submit\" value=\"submit\" />"
}


1;
