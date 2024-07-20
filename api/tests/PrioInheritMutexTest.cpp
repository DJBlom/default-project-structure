/*******************************************************************************
 * Contents: PrioInheritMutex Unit Tests
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include <PrioInheritMutex.h>
extern "C"
{

}



/**********************************TEST LIST************************************
 * 1) The mutex should be inherit with the PRIORITY_INHERITANCE attribute (Done)
 * 2) The mutex should be able to lock (Done)
 * 3) The mutex should be able to unlock (Done)
 * 4) The mutex should be destroyed when no longer used (Done)
 ******************************************************************************/
TEST_GROUP(PrioInheritMutexTest)
{
	bool expectedReturn{true};
	Api::PrioInheritMutex prioInheritMutex;
	void setup()
	{
	}

	void teardown()
	{
	}
};


TEST(PrioInheritMutexTest, LockTheMutex)
{
	CHECK_EQUAL(expectedReturn, prioInheritMutex.Lock());
}


TEST(PrioInheritMutexTest, UnlockTheMutex)
{
	CHECK_EQUAL(expectedReturn, prioInheritMutex.Lock());
	CHECK_EQUAL(expectedReturn, prioInheritMutex.Unlock());
}
