/*******************************************************************************
 * Contents: PrioInheritMute definition
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note:
 ******************************************************************************/
#include <PrioInheritMutex.h>


Api::PrioInheritMutex::PrioInheritMutex()
{
	if (pthread_mutexattr_init(&this->attribute) != status::ok) //GCOV_EXCL_START
		throw System::Errors::construction;

	if (pthread_mutexattr_setprotocol(&this->attribute, PTHREAD_PRIO_INHERIT) != status::ok)
		throw System::Errors::construction;

	if (pthread_mutex_init(&this->mutex, &this->attribute) != status::ok)
		throw System::Errors::construction;
	//GCOV_EXCL_STOP
}


Api::PrioInheritMutex::~PrioInheritMutex()
{
	pthread_mutexattr_destroy(&this->attribute); //GCOV_EXCL_START
	pthread_mutex_destroy(&this->mutex);
	//GCOV_EXCL_STOP
}


[[nodiscard]] bool Api::PrioInheritMutex::Lock() noexcept
{
	bool isLocked{false};
	isLocked = !static_cast<bool> (pthread_mutex_lock(&this->mutex));

	return isLocked;
}


bool Api::PrioInheritMutex::Unlock() noexcept
{
	bool isUnlocked{false};
	isUnlocked = !static_cast<bool> (pthread_mutex_unlock(&this->mutex));

	return isUnlocked;
}
