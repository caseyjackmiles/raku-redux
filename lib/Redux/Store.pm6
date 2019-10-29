unit module Redux::Store;

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
    for @.listeners -> &listener { &listener(); }
    return $action;
  }

  # method subscribe {}
  # method replaceReducer {}
}
