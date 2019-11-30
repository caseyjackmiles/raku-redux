use Test;
use Redux;

plan 2;

my $state = 1;
my $was-invoked = False;
my &mock-reducer = -> $, $ { $was-invoked = True; }
my $action = Redux::Action.new(type => 'ACTIONTYPE');
my $store = Redux::Store.new(app-state => $state, reducer => &mock-reducer);

ok $store.get-state == $state, 'state should be accessible through get-state';

subtest 'Store dispatch', {
  my $result = $store.dispatch($action);
  ok $result === $action, 'dispatch returns the action';
  ok $was-invoked, 'dispatch invokes the reducer function';

  subtest 'invokes listeners', {
    plan 1;
    my $was-invoked = False;
    my &listener = -> { $was-invoked = True; }
    my $store = Redux::Store.new(
            app-state => $state,
            reducer => &mock-reducer);
    $store.subscribe(&listener);
    $store.dispatch($action);

    ok $was-invoked, 'subscribed listener is invoked after dispatch';
  }
}

done-testing;
