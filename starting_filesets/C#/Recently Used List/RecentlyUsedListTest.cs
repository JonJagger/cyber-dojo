
using NUnit.Framework;

[TestFixture]
public class RecentlyUsedListTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new RecentlyUsedList().Answer;
        Assert.AreEqual(expected, actual);
    }
}

