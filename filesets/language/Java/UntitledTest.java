
import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest 
{
    @Test
    public void hitch_hiker()
    {
        int expected = 9 * 6;
        int actual = Untitled.answer();
        assertEquals(expected, actual);
    }
}
