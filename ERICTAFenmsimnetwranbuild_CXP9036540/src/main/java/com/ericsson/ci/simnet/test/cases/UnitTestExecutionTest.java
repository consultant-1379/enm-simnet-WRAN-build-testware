package com.ericsson.ci.simnet.test.cases;

import javax.inject.Inject;
import javax.inject.Provider;

import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import com.ericsson.ci.simnet.test.operators.UnitTestExecutionOperator;
import com.ericsson.ci.simnet.test.operators.UTestExecutionOperator;
import com.ericsson.cifwk.taf.TafTestBase;
import com.ericsson.cifwk.taf.annotations.*;

/**
 * Executes scripts and verify expected output
 */
public class UnitTestExecutionTest extends TafTestBase {

    @Inject
   /* OperatorRegistry<UTestExecutionOperator> operatorRegistry;*/
   Provider<UnitTestExecutionOperator> operatorRegistry;

    @BeforeSuite
    public void initialise() {
        assertThat(UnitTestExecutionOperator.initialise(),is(true));
    }

    /**
     * Executes scripts on a remote server which defined in host.properties file.
     *
     * @DESCRIPTION Verify the script executions
     * @PRE Copy the scripts to remote server be tested
     * @VUsers 1
     * @PRIORITY HIGH Note: NETSUP-2838 Check html report for full explanation behind failures
     */
     @TestId(id = "NETSUP-2838", title = "Verify the script executions")
    @Test(groups = { "Acceptance" })
    @DataDriven(name = "UnitTestExecutionTest")
    public void verifyUnitTestExecution(@Input("command") final String command, @Output("expectedExitCode") final int expectedExitCode) {

        final UTestExecutionOperator seOperator = operatorRegistry.get();
        final int scriptExecutionExitCode = seOperator.verifyUnitTestExecution(command);

        final boolean testCondition = scriptExecutionExitCode == expectedExitCode;

        if (!testCondition) {
            throw new TestCaseException("Returned exit code: " + scriptExecutionExitCode + ",  while expecting exit code: " + expectedExitCode);
        }

        assertThat(testCondition,is(true));

    }
}
