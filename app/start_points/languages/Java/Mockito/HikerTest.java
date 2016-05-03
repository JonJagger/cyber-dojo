import org.junit.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class HikerTest {

    @Test
    public void life_the_universe_and_everything() {
        HikerHelper mock = mock(HikerHelper.class);
        Hiker douglas = new Hiker(mock);
        int expected = 42;
        when(mock.multiplier()).thenReturn(9);
        int actual = douglas.answer();
        assertEquals(expected, actual);
    }
}
