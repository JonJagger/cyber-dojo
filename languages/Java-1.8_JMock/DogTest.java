import org.junit.*;
import org.jmock.*;
import org.jmock.integration.junit4.*;
import static org.junit.Assert.*;

public class DogTest {
    @Rule public JUnitRuleMockery context = new JUnitRuleMockery();

    private Waggable tail = context.mock(Waggable.class);
    private Dog dog = new Dog(tail);

    @Test
    public void tell_dont_ask() {
        context.checking(new Expectations() {{
            oneOf(tail).wag();
        }});
        dog.expressHappiness();
    }
}
