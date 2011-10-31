
using NUnit.Framework;

[TestFixture]
public class YahtzeeTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new Yahtzee().Answer;
        Assert.AreEqual(expected, actual);
    }
}

