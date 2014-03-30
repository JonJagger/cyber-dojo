import org.junit.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class UntitledTest {

    @Test
    public void hitch_hiker() {
        UntitledHelper mock = mock(UntitledHelper.class);
        Untitled target = new Untitled(mock);
        int expected = 42;
        when(mock.answer()).thenReturn(6 * 9);
        int actual = target.answer();
        assertEquals(expected, actual);
    }
}
