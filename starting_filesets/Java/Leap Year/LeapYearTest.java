
import org.junit.*;
import static org.junit.Assert.*;

public class LeapYearTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new LeapYear().answer();
        assertEquals(expected, actual);
    }
}
