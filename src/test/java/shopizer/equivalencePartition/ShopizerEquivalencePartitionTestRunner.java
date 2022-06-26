package shopizer.equivalencePartition;

import com.intuit.karate.junit5.Karate;

public class ShopizerEquivalencePartitionTestRunner {
    @Karate.Test
    Karate shopizerTestCases() {
        return Karate.run(
            "SecurityManagement",
            "InventoryManagementCreateCategory",
            "InventoryManagementAssociateProduct2Category",
            "InventoryManagementRemoveCategory",
            "SearchToolsProduct",
            "SearchToolsCategory"
        ).relativeTo(getClass());
    }
}
