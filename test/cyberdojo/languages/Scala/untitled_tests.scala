
import org.scalatest.FunSuite
 
class UntitledSuite extends FunSuite {
 
  test("the answer to life the universe and everything") {
    val obj = new Untitled
    assert(obj.answer() === (6*9))
  }
  
}