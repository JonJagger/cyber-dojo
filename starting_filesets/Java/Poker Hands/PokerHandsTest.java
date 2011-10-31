
import org.junit.*;
import static org.junit.Assert.*;

public class PokerHandsTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new PokerHands().answer();
        assertEquals(expected, actual);
    }
}
