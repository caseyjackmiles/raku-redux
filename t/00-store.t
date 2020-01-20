use Test;
use Redux;

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

subtest 'Store subscribe', {
  my $invoked = False;
  my &listener =  -> { $invoked = True; };
  my &listener2 = -> { };

  subtest 'adds to listeners', {
    my $store = Redux::Store.new(app-state => [], reducer => -> {});
    ok $store.listeners.elems == 0, 'initial store has 0 listeners';
    $store.subscribe(&listener);
    ok $store.listeners.elems == 1, 'listener was added to store';
    ok $store.listeners[0] === &listener, 'listener was added to store';
  }

  subtest 'returns unsubscriber', {
    my $store = Redux::Store.new(app-state => [], reducer => -> $,$ {} );
    ok $store.listeners.elems == 0, 'initial store has 0 listeners';
    my &unsubscribe = $store.subscribe(&listener);
    $store.subscribe(&listener2);
    ok $store.listeners.elems == 2, 'listeners added to store';
    $store.dispatch($action);
    ok $invoked, 'listeners should be invoked';

    &unsubscribe();
    ok $store.listeners.elems == 2, 'listener is removed after unsubscribing';
    $invoked = False;
    $store.dispatch($action);
    is $invoked, False, 'listener not invoked after unsubscribing';
    is ($store.listeners.first: * === &listener), Nil, 'unsubscribe removes listener';
  }
}

subtest 'replace-reducer', {
  my &original = -> $,$ { 'Original reducer' };
  my $store = Redux::Store.new(app-state => [], reducer => &original);

  my &new = -> $,$ { 'New reducer' };
  $store.replace-reducer(&new);
  $store.dispatch(Redux::Action.new(type => 'action'));
  is $store.get-state, 'New reducer', 'reducer is replaced';
}

done-testing;
