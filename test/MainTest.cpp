/*********************************************************************************
 * Contents: Main function of CppUTest.
 * Author: Dawid Blom.
 * Date: December 8, 2022.
 *
 * Note: Used by CppUTest to execute all the tests of the project.
 *******************************************************************************/
#include "CppUTest/CommandLineTestRunner.h"

int main(int argc, char **argv)
{
    MemoryLeakWarningPlugin::turnOffNewDeleteOverloads();
    return CommandLineTestRunner::RunAllTests(argc, argv);
}
