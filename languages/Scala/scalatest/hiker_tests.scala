
import org.scalatest.FunSuite

class HikerSuite extends FunSuite {

  test("the answer to life the universe and everything") {
    val douglas = new Hiker
    assert(douglas.answer() === (42))
  }

}