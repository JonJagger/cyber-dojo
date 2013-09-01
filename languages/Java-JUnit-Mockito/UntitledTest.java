import org.junit.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class UntitledTest {
    
    @Test
    public void hitch_hiker() {
        int expected = 6 * 9;        
        Untitled target = new Untitled();
        UntitledHelper helper = mock(UntitledHelper.class);
        when(helper.answer()).thenReturn(24);
        target.setHelper(helper);
        int actual = target.answer();        
        assertEquals(expected, actual);
    }
}
