use inc::Module::Install;
name 'Railsish';
all_from 'lib/Railsish.pm';

requires
    'HTTP::Engine' => '0.0.21',
    'Module::Reresh' => '0.13',
    'Binding' => '0.04',
    'Template' => '2.20',
    'Perl6::Junctions' => '1.4000';
    
tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
