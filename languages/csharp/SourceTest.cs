
using NUnit.Framework;

[TestFixture]
public class SourceTest
{
    [Test]
    public void Hhg()
    {
        Assert.AreEqual(42, new Source().M());
    }
}

