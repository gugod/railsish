use Test::More 'no_plan';
use Railsish::Bootstrap;

can_ok("Railsish::Bootstrap", qw(load_configs load_controllers load_helpers));

for (qw(controllers helpers models)) {
  ok(grep /$_/, @INC);
}
