use Test;
use Redux;

plan 1;

my $store = Redux::Store.new(app-state => 1, reducer => -> {});
ok $store.get-state == 1, 'get-state should return state';

done-testing;
