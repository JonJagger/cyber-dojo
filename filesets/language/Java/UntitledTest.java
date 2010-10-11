
import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest 
{
    @Test
    public void hitch_hiker()
    {
        int expected = 42;
        int actual = new Untitled().answer();
        assertEquals(expected, actual);
    }
}
