/********************************************************************************
 * Contents: Logger Unit Tests
 * Author: Dawid Blom
 * Date: April 13, 2023
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 *******************************************************************************/
extern "C" 
{

}

#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"


TEST_GROUP(Template)
{
    void setup()
    {
    }

    void teardown()
    {
    }
};

TEST(Template, DemoTest)
{
    CHECK_EQUAL(1, 1);
}














