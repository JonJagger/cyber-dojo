
import org.junit.*;
import static org.junit.Assert.*;

public class RomanNumeralsTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new RomanNumerals().answer();
        assertEquals(expected, actual);
    }
}
