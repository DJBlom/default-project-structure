/*******************************************************************************
 * Contents: RealtimeThread Unit Tests
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include <iostream>
#include <Services.h>
#include <RealtimeThread.h>
extern "C"
{

}



/**********************************TEST LIST************************************
 * 1) Each thread should be initialized with the following attributes (Done)
 * > - inheritance = PTHREAD_EXPLICIT_SCHED
 * > - policy = SCHED_FIFO
 * > - affinity = a specified core number
 * > - priority = in decremented order
 * 2) The thread should ready to start after creation (Done)
 * 3) The thread should stop when specified (Done)
 ******************************************************************************/
TEST_GROUP(RealtimeAffinityThreadTest)
{
	bool expectedReturn{true};
	Api::RealtimeThread sequencer{1, 99};
	Api::RealtimeThread input{1, 98};
	Api::RealtimeThread processData{1, 97};
	Api::RealtimeThread output{1, 96};
	void setup()
	{
	}

	void teardown()
	{
	}
};


TEST(RealtimeAffinityThreadTest, VerifyAffinitySequencerThread)
{
	CHECK_EQUAL(expectedReturn, sequencer.Prepare(&System::Services::Sequencer));
	CHECK_EQUAL(expectedReturn, input.Prepare(&System::Services::Input));
	CHECK_EQUAL(expectedReturn, processData.Prepare(&System::Services::ProcessData));
	CHECK_EQUAL(expectedReturn, output.Prepare(&System::Services::Output));

	for (long i = 0; i < 600000000; i++) {}
	CHECK_EQUAL(expectedReturn, System::Services::Abort(true));
	CHECK_EQUAL(expectedReturn, sequencer.Start());
	CHECK_EQUAL(expectedReturn, input.Start());
	CHECK_EQUAL(expectedReturn, processData.Start());
	CHECK_EQUAL(expectedReturn, output.Start());
}





/**********************************TEST LIST************************************
 * 1) Each thread should be initialized with the following attributes (Done)
 * > - inheritance = PTHREAD_EXPLICIT_SCHED
 * > - policy = SCHED_FIFO
 * > - priority = in decremented order
 * 2) The thread should ready to start after creation (Done)
 * 3) The thread should stop when specified (Done)
 ******************************************************************************/
TEST_GROUP(RealtimeThreadTest)
{
	bool expectedReturn{true};
	Api::RealtimeThread sequencer{99};
	Api::RealtimeThread input{98};
	Api::RealtimeThread processData{97};
	Api::RealtimeThread output{96};
	void setup()
	{
	}

	void teardown()
	{
	}
};


TEST(RealtimeThreadTest, VerifyAffinitySequencerThread)
{
	CHECK_EQUAL(expectedReturn, sequencer.Prepare(&System::Services::Sequencer));
	CHECK_EQUAL(expectedReturn, input.Prepare(&System::Services::Input));
	CHECK_EQUAL(expectedReturn, processData.Prepare(&System::Services::ProcessData));
	CHECK_EQUAL(expectedReturn, output.Prepare(&System::Services::Output));

	for (long i = 0; i < 600000000; i++) {}
	CHECK_EQUAL(expectedReturn, System::Services::Abort(true));
	CHECK_EQUAL(expectedReturn, sequencer.Start());
	CHECK_EQUAL(expectedReturn, input.Start());
	CHECK_EQUAL(expectedReturn, processData.Start());
	CHECK_EQUAL(expectedReturn, output.Start());
}
