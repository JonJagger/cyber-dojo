
import org.junit.*;
import static org.junit.Assert.*;

public class RecentlyUsedListTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new RecentlyUsedList().answer();
        assertEquals(expected, actual);
    }
}
