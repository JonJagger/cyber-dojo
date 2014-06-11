-module(hiker_tests).
-include_lib("eunit/include/eunit.hrl").
-import(hiker, [answer/0]).

life_the_universe_and_everything_test() ->
  ?assertEqual(42, hiker:answer()).
