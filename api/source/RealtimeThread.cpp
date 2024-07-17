/*******************************************************************************
 * Contents: RealtimeThread definition
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#include <RealtimeThread.h>

Api::RealtimeThread::RealtimeThread(const int& priority)
{
	this->threadPriority = sched_get_priority_max(this->policy);
	if (priority > this->threadPriority) //GCOV_EXCL_START
		throw System::Errors::construction;

	if (pthread_attr_init(&this->attribute) != status::ok)
		throw System::Errors::construction;

	if (pthread_attr_setinheritsched(&this->attribute, this->inheritSched) != status::ok)
		throw System::Errors::construction;

	if (pthread_attr_setschedpolicy(&this->attribute, this->policy) != status::ok)
		throw System::Errors::construction;

	struct sched_param param{priority};
	if (pthread_attr_setschedparam(&this->attribute, &param) != status::ok)
		throw System::Errors::construction;
	//GCOV_EXCL_STOP
}

Api::RealtimeThread::RealtimeThread(const std::size_t& core, const int& priority)
{
	this->threadPriority = sched_get_priority_max(this->policy);
	if (priority > this->threadPriority) //GCOV_EXCL_START
		throw System::Errors::construction;

	if (pthread_attr_init(&this->attribute) != status::ok)
		throw System::Errors::construction;

	if (pthread_attr_setinheritsched(&this->attribute, this->inheritSched) != status::ok)
		throw System::Errors::construction;

	if (pthread_attr_setschedpolicy(&this->attribute, this->policy) != status::ok)
		throw System::Errors::construction;

	CPU_ZERO(&this->cpuSet);
	CPU_SET(core, &this->cpuSet);
	if (pthread_attr_setaffinity_np(&this->attribute, sizeof(cpu_set_t), &this->cpuSet) != status::ok)
		throw System::Errors::construction;

	struct sched_param param{priority};
	if (pthread_attr_setschedparam(&this->attribute, &param) != status::ok)
		throw System::Errors::construction;
	//GCOV_EXCL_STOP
}


Api::RealtimeThread::~RealtimeThread()
{
	pthread_attr_destroy(&this->attribute); //GCOV_EXCL_LINE
}


[[nodiscard]] bool Api::RealtimeThread::Prepare(void* (*serviceFunction)(void*)) noexcept
{
	bool isStarted{false};
	isStarted = !static_cast<bool> (pthread_create(&this->thread, &this->attribute, serviceFunction, nullptr));

	return isStarted;
}

[[nodiscard]] bool Api::RealtimeThread::Start() noexcept
{
	bool isStopped{false};
	isStopped = !static_cast<bool> (pthread_join(this->thread, nullptr));

	return isStopped;
}
