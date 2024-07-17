/********************************************************************************
 * Contents: The main function
 * Author: Dawid Blom
 * Date: April 13, 2023
 *
 * Note:
 *******************************************************************************/
#include <unistd.h>
#include <Errors.h>
#include <iostream>
#include <Control.h>


int main(void)
{
	try
	{
		pid_t pid = getpid();
		System::Control control{pid};
		if (control.Start() == true)
        {
			syslog(LOG_CRIT, "System Started\n");
        }
        else
        {
            if (control.Shutdown() == true)
            {
                syslog(LOG_CRIT, "System Shutting Down\n");
            }
        }
	}
	catch (System::Errors& e)
	{
		syslog(LOG_CRIT, "Unable To Start The System %d", static_cast<int> (e));
	}

	return 0;
}
