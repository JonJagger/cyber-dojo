
public class Untitled {

    public Untitled() {    
        helper = new UntitledHelper();
    }
        
    public int answer() {
        return helper.answer();
    }

    public void setHelper(UntitledHelper helper) {
        this.helper = helper;
    }

    private UntitledHelper helper;
}
