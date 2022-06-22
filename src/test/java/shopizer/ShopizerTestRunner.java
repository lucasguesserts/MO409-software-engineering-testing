package shopizer;

import com.intuit.karate.junit5.Karate;

public class ShopizerTestRunner {
    @Karate.Test
    Karate shopizerTestCases() {
        return Karate.run(
            "createProducts",
            "createCategories",
            "associateProducts2Categories",
            "removeProducts",
            "removeCategories"
        ).relativeTo(getClass());
    }
}
