
using NUnit.Framework;

[TestFixture]
public class PrimeFactorsTest
{
    [Test]
    public void Example()
    {
        int expected = 6 * 9;
        int actual = new PrimeFactors().Answer;
        Assert.AreEqual(expected, actual);
    }
}

