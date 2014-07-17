module HikerTest.``example``

open NUnit.Framework

[<Test>]
let ``life, the universe, and everything.`` () =
   Are.Equal(42,Hiker.answer)
   ()