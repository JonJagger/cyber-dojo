
using NUnit.Framework;

[TestFixture]
public class PokerHandsTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new PokerHands().Answer;
        Assert.AreEqual(expected, actual);
    }
}

