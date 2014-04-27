
public final class Config {

    public static Config getInstance() {
        return singleton;
    }

    public int getMultiplier() {
        return 9;
    }

    private Config() {
    }

    private static Config singleton = new Config();
}
