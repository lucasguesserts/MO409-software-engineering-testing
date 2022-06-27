package shopizer;

import com.intuit.karate.junit5.Karate;

public class ShopizerTestRunner {
    @Karate.Test
    Karate userStoryTestCases() {
        return Karate.run(
            "userStory/createProducts",
            "userStory/createCategories",
            "userStory/associateProducts2Categories",
            "userStory/checkProductsOnStore",
            "userStory/removeProducts",
            "userStory/removeCategories",
            "equivalencePartition/SecurityManagement",
            "equivalencePartition/InventoryManagementCreateCategory",
            "equivalencePartition/InventoryManagementAssociateProduct2Category",
            "equivalencePartition/InventoryManagementRemoveCategory",
            "equivalencePartition/SearchToolsProduct",
            "equivalencePartition/SearchToolsCategory"
        ).relativeTo(getClass());
    }
}
