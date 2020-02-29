# raku-redux

Redux-styled state management for Raku

## development test-drive

Start REPL with library preloaded: `PERL6LIB=lib perl6`

```perl6
use Redux;
my $counter = 0;
my &reducer = -> $state, $action {
  given $action.type {
    when 'increment' { $state + 1 }
    when 'decrement' { $state - 1 }
    default { $state }
  }
}

my $store = create-store(&reducer, $counter);
$store.dispatch(Action.new(type => 'increment'));
say $store.get-state; # prints 1
```


## testing

Ensure `prove6` is installed on your system; it is likely included with the
rakudo-star distribution.

```
$ prove6 --lib t/
```
