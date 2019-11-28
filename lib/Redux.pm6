unit module Redux;

constant &no-op = -> {};

role Action is export {
  has Str $.type is required;
}

class Store is export {
  has $!app-state is required;
  has &!reducer is required;
  has @.listeners = ();

  submethod BUILD(:$!app-state, :&!reducer) { }

  method get-state {
    return $!app-state;
  }

  method dispatch(Action $action) {
    $!app-state = &!reducer($!app-state, $action);

    # Invoke each subscribed listener.
    # If a listener is undefined, invoke a no-op.
    # TODO: Convert to Supply/Tap API
    for @.listeners { $^listener() // no-op() }
    return $action;
  }

  method subscribe(&listener) {
    # TODO: Convert to Supply/Tap API
    @.listeners.push(&listener);
    my $index = @.listeners.end;
    return -> { @.listeners[$index]:delete; @.listeners[$index] = no-op; };
  }

  # method replaceReducer {}
}
