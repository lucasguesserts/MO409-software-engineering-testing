package shopizer.stateTransition;

import com.intuit.karate.junit5.Karate;

public class StateTransitionTestRunner {
    @Karate.Test
    Karate userStoryTestCases() {
        return Karate.run(
            "H1", "H2", "H3", "H4"
        ).relativeTo(getClass());
    }
}
