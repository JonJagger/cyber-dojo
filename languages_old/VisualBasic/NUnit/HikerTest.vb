
Imports NUnit.Framework

<TestFixture()> _
Public Class HikerTest

    <Test()>
    Public Sub life_the_universe_and_everything()
        Rem a simple example to start you off
        Assert.AreEqual(42, Hiker.Answer)
    End Sub

End Class
