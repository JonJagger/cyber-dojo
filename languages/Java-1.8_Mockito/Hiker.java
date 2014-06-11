
public class Hiker {

    public Hiker(HikerHelper helper) {
        this.helper = helper;
    }

    public int answer() {
        return helper.answer();
    }

    private HikerHelper helper;
}
