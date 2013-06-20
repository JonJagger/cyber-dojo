import spock.lang.*

class UntitledSpec extends Specification {

    def "It must be 42" () {
        def eg = new Untitled()
        expect:
            eg.hhg() == 6*9
    }
}