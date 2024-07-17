/*******************************************************************************
 * Contents: RingBuffer Unit Tests
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include "RingBuffer.h"

extern "C"
{

}


static constexpr int bufferSize{5};


/**********************************TEST LIST************************************
 * 1) Should be initialized with a fixed size (Done)
 * 2) Must be able to handle any data type (Done)
 * 3) When full it should wrap around (Done)
 * 4) Should keep track of the size as it grows (Done)
 * 5) Have a method to add more an element (Done)
 * 6) Have a method to retrieve an element (Done)
 * 7) Have a way to check if the buffer is empty (Done)
 * 8) Should be allocated on the stack (Done)
 * 9) When empty it should return false (Done)
 * 10) Users should be able to copy the ring buffer (Done)
 * 11) Users shoudl be able to move the ring buffer (Done)
 ******************************************************************************/
TEST_GROUP(RingBufferTest)
{
    int data{5};
    int result{0};
    int expected{0};
    Algorithm::RingBuffer<int, bufferSize> input;
	void setup()
	{
	}

	void teardown()
	{
	}
};

TEST(RingBufferTest, InsertAnElement)
{
    input.Insert(data);
    CHECK_EQUAL(false, input.Empty());
}

TEST(RingBufferTest, RemoveAnElement)
{
    expected = 5;
    data = 5;
    input.Insert(data);
    if (input.Retrieve(result))
    {
    }

    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, ManageContinuousBufferOverflows)
{
    expected = 29;
    for (int i = 0; i <= 33; i++)
    {
        input.Insert(i);
    }

    CHECK_EQUAL(true, input.Retrieve(result));
    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, ManageContinuousBufferUnderflows)
{
    expected = 13;
    for (int i = 0; i < 14; i++)
    {
        input.Insert(i);
    }

    for (int i = 0; i < 20; i++)
    {
        if (!input.Retrieve(result))
        {
        }
    }

    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, RandomSanityCheck1)
{
    expected = 27;
    for (int i = 0; i < 28; i++)
    {
        input.Insert(i);
    }

    for (int i = 0; i < 20; i++)
    {
        if (!input.Retrieve(result))
        {
        }
    }

    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, RandomSanityCheck2)
{
    expected = 17;
    for (int i = 0; i < 22; i++)
    {
        input.Insert(i);
    }

    CHECK_EQUAL(true, input.Retrieve(result));
    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, EnsureObjectToBeCopyable)
{
    expected = 1;
    for (int i = 0; i < 5; i++)
    {
        input.Insert(i+1);
    }

    Algorithm::RingBuffer<int, bufferSize> rb;

    rb = input;
    if (input.Retrieve(result))
    {
    }
    CHECK_EQUAL(expected, result);

    if (rb.Retrieve(result))
    {
    }
    CHECK_EQUAL(expected, result);
}

TEST(RingBufferTest, EnsureObjectToBeMoveable)
{
    for (int i = 0; i < 5; i++)
    {
        input.Insert(i);
    }
    Algorithm::RingBuffer<int, bufferSize> rb = std::move(input);
}
