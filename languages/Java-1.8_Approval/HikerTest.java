import org.junit.*;
import static org.junit.Assert.*;

import org.approvaltests.Approvals;
import org.approvaltests.reporters.UseReporter;
import org.approvaltests.reporters.JunitReporter;

@UseReporter(JunitReporter.class)
public class HikerTest {

    @Test
    public void life_the_universe_and_everything() throws Exception {
        int actual = Hiker.answer();
        Approvals.verify("" + actual);
    }
}
