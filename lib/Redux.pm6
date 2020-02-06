unit module Redux;

role Action is export {
  has Str $.type is required;
}

class Store is export {
  has $!state is required;
  has &!reducer is required;
  has Callable @.listeners;

  submethod BUILD(:$!state, :&!reducer) { }

  method get-state {
    $!state;
  }

  method dispatch(Action $action) {
    $!state = &!reducer($!state, $action);

    # TODO: Convert to Supply/Tap API
    for @.listeners { $_() } # invoke each subscribed listener
    $action;
  }

  method subscribe(&listener) {
    # TODO: Convert to Supply/Tap API
    @.listeners.push(&listener);
    -> { @.listeners = @.listeners.grep({ !($_ === &listener) }) }; # unsubscribes listener when invoked
  }

  method replace-reducer(&next-reducer) {
    &!reducer = &next-reducer;
  }
}
