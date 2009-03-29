package Railsish::Logger;
use Mouse;
use Railsish::CoreHelpers ();
use Log::Dispatch;
use Log::Dispatch::File;
use Log::Dispatch::Screen;

has 'logger' => (
    is => "rw",
    isa => "Log::Dispatch",
    lazy_build => 1
);

sub _build_logger {
    my ($self) = @_;

    my $logger = Log::Dispatch->new;
    return $logger unless exists $ENV{APP_ROOT};

    my $logdir = Railsish::CoreHelpers::app_root("log");
    if (-d $logdir) {
        my $file = Railsish::CoreHelpers::app_root(log => "development.log");
        $logger->add(
            Log::Dispatch::File->new(
                name => "development",
                min_level => "debug",
                filename => $file));
    }

    $logger->add(
	Log::Dispatch::Screen->new(
	    name => "screen",
	    min_level => "debug",
            stderr => 1));

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
