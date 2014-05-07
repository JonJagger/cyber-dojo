import cucumber.api.junit.Cucumber;
import cucumber.api.SnippetType;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@Cucumber.Options(strict=true, format="junit:output", snippets=SnippetType.CAMELCASE)
public class RunCukesTest {
    // this is the adapter/bridge code
    // between cucumber jvm and junit
    // you do not need to edit this
}
 