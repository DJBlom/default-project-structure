/*******************************************************************************
 * Contents: Socket Unit Tests
 * Author: Dawid Blom
 * Date: March 27, 2024
 *
 * Note: Refer to the TEST LIST for details on what this fixture tests.
 ******************************************************************************/
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

extern "C"
{

}


/**********************************TEST LIST************************************
 * 1) Default constructor should create a INET UDP socket
 * 2) Single argument constructor should take domain argument
 * 3) Add ability to bind to an address (Server)
 * 4) Send data to another socket (Server/Client) (Interface)
 * 5) Receive data from another socket (Server/Client) (Interface)
 * 6) Ensure the socket is opened as a non blocking socket (Server/Client)
 * 7) The socket should operate on a specified port (Server/client)
 * 8) Ability to establish a peer to peer connection (Client)
 *
 ******************************************************************************/
TEST_GROUP(UdpSocketTest)
{
	void setup()
	{
	}

	void teardown()
	{
	}
};

TEST(UdpSocketTest, ConstructSocketWithDefaultInetUdp)
{
    CHECK_EQUAL(1, 1);
}
