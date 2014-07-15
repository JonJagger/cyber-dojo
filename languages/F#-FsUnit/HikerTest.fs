module HikerTest.``example``

open NUnit.Framework
open FsUnit

[<Test>]
let ``life, the universe, and everything.`` () =
    Hiker.answer |> should equal 42