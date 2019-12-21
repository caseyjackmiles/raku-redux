unit module Redux;

role Action is export {
  has Str $.type is required;
}

class Store is export {
  has $!app-state is required;
  has &!reducer is required;
  has @.listeners;

  submethod BUILD(:$!app-state, :&!reducer) { }

  method get-state {
    return $!app-state;
  }

  method dispatch(Action $action) {
    $!app-state = &!reducer($!app-state, $action);

    # Invoke each subscribed listener.
    # TODO: Convert to Supply/Tap API
    for @.listeners { &^listener(); }
    return $action;
  }

  method subscribe(&listener) {
    # TODO: Convert to Supply/Tap API
    @.listeners.push(&listener);
    my $index = @.listeners.end;
    return -> { @.listeners[$index]:delete; }
  }

  # method replaceReducer {}
}
