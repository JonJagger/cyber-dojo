import org.junit.*;
import static org.junit.Assert.*;
import cucumber.annotation.en.*;
import cucumber.runtime.*;

public class UntitledStepDef {

    private int answer;
    
    @Given("^the hitch-hiker selects some tiles$")
    public void the_hitch_hiker_selects_some_tiles() throws Throwable {
    }
    
    @When("^they spell (\\d+) times (\\d+)$")
    public void they_spell_times(int arg1, int arg2) throws Throwable {
        answer = Untitled.answer(arg1,arg2);
    }

    @Then("^the score is (\\d+)$")
    public void the_score_is(int expected) throws Throwable {
        assertEquals(expected, answer);
    }
}
