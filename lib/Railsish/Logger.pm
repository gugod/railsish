package Railsish::Logger;
use Moose;
use Railsish::CoreHelpers ();
use Log::Dispatch;
use Log::Dispatch::File;

has 'logger' => (
    is => "rw",
    isa => "Log::Dispatch",
    lazy_build => 1
);

sub _build_logger {
    my ($self) = @_;

    my $logger = Log::Dispatch->new;
    $logger->add(
	Log::Dispatch::File->new(
	    name => "development",
	    min_level => "debug",
	    filename => Railsish::CoreHelpers::app_root(log => "development.log")));

    return $logger;
}

sub debug {
    my ($self, $message) = @_;
    $self->logger->log(
	level => "debug",
	message => $message . "\n"
    );
}

__PACKAGE__->meta->make_immutable;

1;
