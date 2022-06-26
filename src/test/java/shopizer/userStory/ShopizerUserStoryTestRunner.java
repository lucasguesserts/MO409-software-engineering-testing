package shopizer.userStory;

import com.intuit.karate.junit5.Karate;

public class ShopizerUserStoryTestRunner {
    @Karate.Test
    Karate shopizerTestCases() {
        return Karate.run(
            "createProducts",
            "createCategories",
            "associateProducts2Categories",
            "checkProductsOnStore",
            "removeProducts",
            "removeCategories"
        ).relativeTo(getClass());
    }
}
