
import org.junit.*;
import static org.junit.Assert.*;

public class BowlingGameTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new BowlingGame.answer();
        assertEquals(expected, actual);
    }
}
