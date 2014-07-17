module HikerTest.``example``

open NUnit.Framework

let AreEqual tuple =
   match tuple with
   | (expected,actual) ->
      if (expected<>actual) then
         Assert.Fail(System.String.Format("Expected {0}, Actual {1}", expected, actual))


[<Test>]
let ``life, the universe, and everything.`` () =
   AreEqual(42,Hiker.answer)
   ()