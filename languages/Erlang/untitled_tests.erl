-module(untitled_tests).
-include_lib("eunit/include/eunit.hrl").
-import(untitled, [answer/0]).

answer_test() ->
  ?assertEqual(6*9, untitled:answer()).
