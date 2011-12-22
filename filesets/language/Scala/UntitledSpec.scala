import org.scalatest.FlatSpec
import org.scalatest.matchers.ShouldMatchers

class UntitledSpec extends FlatSpec with ShouldMatchers {

  "Hitchhiker" should "be 42" in {
    val untitled = new Untitled
    untitled.answer() should equal (42)
  }

}

