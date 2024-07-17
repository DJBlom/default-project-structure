/*******************************************************************************
 * Contents: BinarySemaphore definition
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note:
 ******************************************************************************/
#include <BinarySemaphore.h>
#include <iostream>


Api::BinarySemaphore::BinarySemaphore()
{
	if (sem_init(&this->semaphore, init::p_shared, init::value) != status::ok)
		throw System::Errors::construction; //GCOV_EXCL_LINE
}


Api::BinarySemaphore::~BinarySemaphore()
{
	sem_destroy(&this->semaphore); //GCOV_EXCL_LINE
}


[[nodiscard]] bool Api::BinarySemaphore::Acquire() noexcept
{
	bool isAcquired{false};
	isAcquired = !static_cast<bool> (sem_wait(&this->semaphore));

	return isAcquired;
}


[[nodiscard]] bool Api::BinarySemaphore::Release() noexcept
{
	bool isReleased{false};
	isReleased = !static_cast<bool> (sem_post(&this->semaphore));

	return isReleased;
}
