import org.scalatest.FunSuite

class HikerSuite extends FunSuite {
  test("the answer to life the universe and everything") {
    assert(Hiker.answer == 42)
  }
}
