import static org.junit.Assert.*
import org.junit.*

class HikerTest {
    @Test
    void life_the_universe_and_everything() {
        def douglas = new Hiker()
        assertTrue douglas.answer() == 42
    }
}
