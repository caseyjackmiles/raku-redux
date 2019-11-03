unit module Redux::Store;

constant $no-op = -> {};

role Action is export {
  has Str $.type is required;
}

class Store is export {
  has $.app-state is required;
  has &.reducer is required;
  has @.listeners = ();

  method get-state {
    return $.app-state;
  }

  method dispatch(Action $action) {
    $.app-state = &.reducer(get-state(), $action);

    # Invoke each subscribed listener.
    # If a listener is undefined; invoke a no-op.
    for @!listeners { $^listener() // $no-op(); }
    return $action;
  }

  method subscribe(&listener) {
    @!listeners.push(&listener);
    my $index = @!listeners.end;
    return -> { @!listeners[$index]:delete; @!listeners[$index] = $no-op; };
  }

  # method replaceReducer {}
}
