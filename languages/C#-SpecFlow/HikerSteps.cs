using System;
using TechTalk.SpecFlow;
using NUnit.Framework;

[Binding]
public class HikerSteps
{
    private int answer;

    [Given(@"life, the universe and everything")]
    public void GivenLifeTheUniverseAndEverything()
    {
        // Life, the universe and everything needs no creation by us
    }

    [When(@"I ask for the meaning")]
    public void WhenIAskForTheMeaning()
    {
        answer = Hiker.Answer;
    }

    [Then(@"the answer is (.*)")]
    public void ThenTheAnswerIs(int expected)
    {
        Assert.AreEqual(expected, answer);
    }
}