module Are

open NUnit.Framework

// Use this for all your tests. See below...

let Equal tuple =
   match tuple with
   | (expected,actual) ->
      if (expected<>actual) then
         Assert.Fail(System.String.Format("Expected {0}, Actual {1}", expected, actual))


//-----------------------------------------------------
// I've spent a lot of time trying and failing to get
// FsUnit working. Specifically if the test looks like this
//- - - - - - - - - - - - - - - - - - - - - - - - - - -
//module HikerTest.``example``
//
//open NUnit.Framework
//open FsUnit
//
//[<Test>]
//let ``life, the universe, and everything.`` () =
//    Hiker.answer |> should equal 42
//- - - - - - - - - - - - - - - - - - - - - - - - - - -
// Then the test starts to run but results in ...
//1) Test Error : HikerTest.example.life, the universe,
// and everything. System.MissingMethodException :
// Method not found: 'FsUnit.TopLevelOperators.should'.
//
// Assert.Equals is also not behaving as I'd except.
//
// For now here's Are.Equal which does appear to work
// and you'll have to use that for all your tests.
// Please help fix this if you can. Thanks.
