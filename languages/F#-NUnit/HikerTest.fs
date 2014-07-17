module HikerTest.``example``

open NUnit.Framework

[<Test>]
let ``life, the universe, and everything.`` () =
   Assert.AreEqual(42,Hiker.answer)
   