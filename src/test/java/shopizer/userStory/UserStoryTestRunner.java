package shopizer.userStory;

import com.intuit.karate.junit5.Karate;

public class UserStoryTestRunner {
    @Karate.Test
    Karate userStoryTestCases() {
        return Karate.run(
            "createProducts",
            "createCategories",
            "associateProducts2Categories",
            "checkProductsOnStore"//,
//            "removeCategories",
//            "removeProducts"
        ).relativeTo(getClass());
    }
}
