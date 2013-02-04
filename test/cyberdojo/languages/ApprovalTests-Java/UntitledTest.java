import org.junit.*;
import static org.junit.Assert.*;

import org.approvaltests.Approvals;
import org.approvaltests.reporters.UseReporter;
import org.approvaltests.reporters.JunitReporter;

@UseReporter(JunitReporter.class)
public class UntitledTest {
    
    @Test
    public void hitch_hiker() throws Exception {
        int actual = Untitled.answer();
        Approvals.verify("" + actual);
    }
}
