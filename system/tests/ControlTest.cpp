/*******************************************************************************
 * Contents: Control Unit Tests
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include <unistd.h>

#include "Control.h"
extern "C"
{

}


/**********************************TEST LIST************************************
 * 1) Verify that the system is ready to begin operation (Done)
 * 2) Start the system up if it's ready (Done)
 * 3) Shutdown the system when on command (Done)
 ******************************************************************************/
TEST_GROUP(ControlTest)
{
	pid_t pid = getpid();
	System::Control control{pid};
	void setup()
	{
	}

	void teardown()
	{
	}
};


TEST(ControlTest, SuccessfullyStartTheSystem)
{
	CHECK_EQUAL(true, control.Shutdown());
	CHECK_EQUAL(true, control.Start());
}


TEST(ControlTest, SuccessfullyShutdownTheSystem)
{
	CHECK_EQUAL(true, control.Shutdown());
}
