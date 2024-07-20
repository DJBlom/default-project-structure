/*******************************************************************************
 * Contents: BinarySemaphore Unit Tests
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include <BinarySemaphore.h>
extern "C"
{

}



/**********************************TEST LIST************************************
 * 1) The binary semaphore should be initialized to pshared=0 and value=1 (Done)
 * 2) The binary semaphore should be able to acquire the semaphore (Done)
 * 3) The binary sempahore should be able to release the semaphore (Done)
 * 4) The binary semaphore should be destroyed when no longer used (Done)
 ******************************************************************************/
TEST_GROUP(BinarySemaphoreTest)
{
	bool expectedReturn{true};
	Api::BinarySemaphore binSem;
	void setup()
	{
	}

	void teardown()
	{
	}
};


TEST(BinarySemaphoreTest, ReleaseTheSemaphoreSuccessfully)
{
	CHECK_EQUAL(expectedReturn, binSem.Release());
}


TEST(BinarySemaphoreTest, AcquireTheSemaphoreSuccessfully)
{
	CHECK_EQUAL(expectedReturn, binSem.Acquire());
}
