
import org.junit.*;
import static org.junit.Assert.*;

public class PrimeFactorsTest 
{
    @Test
    public void example()
    {
        int expected = 6 * 9;
        int actual = new PrimeFactors.answer();
        assertEquals(expected, actual);
    }
}
