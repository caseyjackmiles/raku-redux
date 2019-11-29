use Test;
use Redux;

my $state = 1;
my &mock-reducer = -> $, $action { $action.type };
my $action = Redux::Action.new(type => 'ACTIONTYPE');
my $store = Redux::Store.new(app-state => $state, reducer => &mock-reducer);

ok $store.get-state == $state, 'state should be accessible through get-state';

my $result = $store.dispatch($action);
ok $result === $action, 'dispatch returns the action';
ok $store.get-state eq $action.type, 'state is modified with dispatch';

done-testing;
