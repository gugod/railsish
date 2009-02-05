use inc::Module::Install;
name 'Railsish';
all_from 'lib/Railsish.pm';

requires
    'Binding'		=> '0.04',
    'HTTP::Engine'	=> '0.0.21',
    'HTTPx::Dispatcher' => '0.05',
    'Module::Refresh'	=> '0.13',
    'Perl6::Junction'	=> '1.4000',
    'Template'		=> '2.20',
;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
