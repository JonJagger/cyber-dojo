
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

public class UntitledTest extends TestCase
{
    public void test_hitch_hiker()
    {
        int actual = 6 * 9;
        int expected = 42;
        assertEquals(expected, actual);
    }
}

