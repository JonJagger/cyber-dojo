
using NUnit.Framework;

[TestFixture]
public class BowlingGameTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new BowlingGame().Answer;
        Assert.AreEqual(expected, actual);
    }
}

