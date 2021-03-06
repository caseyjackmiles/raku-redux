use Test;
use Redux;

my $state = 1;
my $was-invoked = False;
my &mock-reducer = -> $, $ { $was-invoked = True; }
my $action = Action.new(type => 'ACTIONTYPE');
my $store = Store.new(state => $state, reducer => &mock-reducer);

ok $store.get-state == $state, 'state should be accessible through get-state';

subtest 'Store dispatch', {
  my $result = $store.dispatch($action);
  ok $result === $action, 'dispatch returns the action';
  ok $was-invoked, 'dispatch invokes the reducer function';

  subtest 'invokes listeners', {
    my $was-invoked = False;
    my &listener = -> { $was-invoked = True; }
    my $store = Store.new(
            state => $state,
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

  subtest 'does not add undefined listeners', {
    my $store = Store.new(state => [], reducer => -> {});
    my &undefined;
    $store.subscribe(&undefined);
    ok $store.listeners.elems == 0, 'undefined listeners are not added';
  }

  subtest 'adds to listeners', {
    my $store = Store.new(state => [], reducer => -> {});
    ok $store.listeners.elems == 0, 'initial store has 0 listeners';
    $store.subscribe(&listener);
    ok $store.listeners.elems == 1, 'listener was added to store';
    ok &listener (elem) $store.listeners, 'listener was added to store';
  }

  subtest 'returns unsubscriber', {
    my $store = Store.new(state => [], reducer => -> $,$ {} );
    ok $store.listeners.elems == 0, 'initial store has 0 listeners';
    my &unsubscribe = $store.subscribe(&listener);
    $store.subscribe(&listener2);
    ok $store.listeners.elems == 2, 'listeners added to store';
    $store.dispatch($action);
    ok $invoked, 'listeners should be invoked';

    unsubscribe();
    ok $store.listeners.elems == 1, 'listener is removed after unsubscribing';
    $invoked = False;
    $store.dispatch($action);
    is $invoked, False, 'listener not invoked after unsubscribing';
    is &listener (elem) $store.listeners, False, 'unsubscribe removes listener';
  }
}

subtest 'replace-reducer', {
  my &original = -> $,$ { 'Original reducer' };
  my $store = Store.new(state => [], reducer => &original);

  my &new = -> $,$ { 'New reducer' };
  $store.replace-reducer(&new);
  $store.dispatch(Action.new(type => 'action'));
  is $store.get-state, 'New reducer', 'reducer is replaced';
}

done-testing;
