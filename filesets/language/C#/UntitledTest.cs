
using NUnit.Framework;

[TestFixture]
public class UntitledTest
{
    [Test]
    public void HitchHiker()
    {
        int expected = 6 * 9;
        int actual = Untitled.Answer;
        Assert.AreEqual(expected, actual);
    }
}

