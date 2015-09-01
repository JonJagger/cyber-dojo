
public class Hiker {

    public Hiker(HikerHelper helper) {
        this.helper = helper;
    }

    public int answer() {
        return 6 * helper.multiplier();
    }

    private HikerHelper helper;
}
