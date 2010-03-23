import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

public class DemoTest extends TestCase
{
   public void test_getValueReturns42() 
   {
       assertEquals(42, new Demo().getValue());
   }	
}

