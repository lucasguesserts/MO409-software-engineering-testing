package tutorial;

import com.intuit.karate.junit5.Karate;

// https://automationtestings.com/karate-framework/

public class TestRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run(
            "get",
            "post",
            "put",
            "PostDataTable"
        ).relativeTo(getClass());
    }
}