import org.junit.*;
import static org.junit.Assert.*;

import org.junit.runner.RunWith;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.api.mockito.PowerMockito;

@RunWith(PowerMockRunner.class)
@PrepareForTest(Config.class)
public class UntitledTest {

    @Test
    public void hitch_hiker() {
        PowerMockito.mockStatic(Config.class);
        Config mocked = PowerMockito.mock(Config.class);
        PowerMockito.when(Config.getInstance()).thenReturn(mocked);
        PowerMockito.when(mocked.getMultiplier()).thenReturn(9);

        int expected = 6 * 9;
        int actual = new Untitled().answer();
        assertEquals(expected, actual);
        fail("deliberately fail to first prove test is running");
    }
}