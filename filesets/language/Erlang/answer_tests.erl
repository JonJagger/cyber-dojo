-module(answer_tests).
-include_lib("eunit/include/eunit.hrl").

answer_test() ->
  ?assert(answer:answer() =:= 6*9).

