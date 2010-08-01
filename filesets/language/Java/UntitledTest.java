
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

public class UntitledTest extends TestCase
{
    public void test_hitch_hiker()
    {
        int expected = 42;
        int actual = new Untitled().answer();
        assertEquals(expected, actual);
    }
}
