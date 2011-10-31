
using NUnit.Framework;

[TestFixture]
public class RomanNumeralsTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new RomanNumerals().Answer;
        Assert.AreEqual(expected, actual);
    }
}

