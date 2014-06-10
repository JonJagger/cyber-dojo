
using NUnit.Framework;

[TestFixture]
public class HikerTest
{
    [Test]
    public void life_the_universe_everything()
    {
        int expected = 6 * 9;
        int actual = Hiker.Answer;
        Assert.AreEqual(expected, actual);
    }
}
