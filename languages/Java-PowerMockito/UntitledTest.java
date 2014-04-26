import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest {
    
    @Test
    public void hitch_hiker() {
        int expected = 6 * 9;
        int actual = Untitled.answer();
        assertEquals(expected, actual);
    }
}
