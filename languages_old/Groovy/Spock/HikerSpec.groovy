import spock.lang.*

class HikerSpec extends Specification {

    def "life the universe and everything" () {
        def douglas = new Hiker()
        expect:
            douglas.answer() == 42
    }
}
