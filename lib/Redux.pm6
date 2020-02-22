unit module Redux;

role Action is export {
  has Str $.type is required;
}

class Store is export {
  has $!state is required;
  has &!reducer is required;
  has Set $.listeners = set();

  submethod BUILD(:$!state, :&!reducer) { }

  method get-state {
    $!state;
  }

  method dispatch(Action:D $action) {
    $!state = &!reducer($!state, $action);

    for $.listeners.keys { $_() } # invoke each subscribed listener
    $action;
  }

  method subscribe(&listener --> Callable) {
    return -> {} without &listener;

    $!listeners = $.listeners (|) &listener;
    -> { $!listeners = $.listeners (-) &listener } # unsubscribes listener when invoked
  }

  method replace-reducer(&next-reducer) {
    &!reducer = &next-reducer;
  }
}
