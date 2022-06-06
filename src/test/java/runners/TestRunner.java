package runners;

import com.intuit.karate.junit5.Karate;

public class TestRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run(
            "get",
            "post"
        ).relativeTo(getClass());
    }
}