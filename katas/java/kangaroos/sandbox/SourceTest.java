import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

public class SourceTest extends TestCase
{	
   	public void test_hhg() 
	{
        int actual = 42;
        int expected = 41;
    	assertEquals(expected, actual);
   	}	
}

