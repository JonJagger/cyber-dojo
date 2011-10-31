
using NUnit.Framework;

[TestFixture]
public class LeapYearTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new LeapYear().Answer;
        Assert.AreEqual(expected, actual);
    }
}

