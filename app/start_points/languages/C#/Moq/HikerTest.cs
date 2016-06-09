using Moq;
using NUnit.Framework;

[TestFixture]
public class HikerTest
{
    [Test]
    public void life_the_universe_and_everything()
    {
        var arthur = new Mock<IHiker>();
        arthur.Setup((foo => foo.Answer())).Returns(6 * 9);

        // a simple example to start you off
        Assert.AreEqual(42, arthur.Object.Answer());
    }
}
