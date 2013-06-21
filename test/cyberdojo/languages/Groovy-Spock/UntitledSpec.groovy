import spock.lang.*

class UntitledSpec extends Specification {

    def "It must be forty two" () {
        def eg = new Untitled()
        expect:
            eg.hhg() == 6*9
    }
}
