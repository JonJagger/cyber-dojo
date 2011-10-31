
import org.junit.*;
import static org.junit.Assert.*;

public class YahtzeeTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new Yahtzee().answer();
        assertEquals(expected, actual);
    }
}
