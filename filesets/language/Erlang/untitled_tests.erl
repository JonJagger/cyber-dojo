-module(untitled_tests).
-include_lib("eunit/include/eunit.hrl").

answer_test() ->
  ?assert(untitled:answer() =:= 6*9).

