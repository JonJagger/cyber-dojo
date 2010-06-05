
using NUnit.Framework;

[TestFixture]
public class UntitledTest
{
    [Test]
    public void HitchHiker()
    {
        Assert.AreEqual(42, new Untitled().Answer);
    }
}

