/*******************************************************************************
 * Contents: Control implementation
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#include <Control.h>


System::Control::Control(const pid_t& pid) //GCOVR_EXCL_START
{
	struct sched_param param{0};
	this->priority = sched_get_priority_max(this->policy);
	param.sched_priority = this->priority;
	if (sched_setscheduler(pid, this->policy, &param) != status::ok)
		throw System::Errors::construction;
}
//GCOVR_EXCL_STOP


[[nodiscard]] bool System::Control::Start() noexcept //GCOVR_EXCL_START
{
	if (this->sequencer.Prepare(&System::Services::Sequencer) == false)
		return false;

	if (this->input.Prepare(&System::Services::Input) == false)
		return false;

	if (this->processData.Prepare(&System::Services::ProcessData) == false)
		return false;

	if (this->output.Prepare(&System::Services::Output) == false)
		return false;

	if (this->sequencer.Start() == false)
		return false;

	if (this->input.Start() == false)
		return false;

	if (this->processData.Start() == false)
		return false;

	if (this->output.Start() == false)
		return false;

	return true;
}
//GCOVR_EXCL_STOP


[[nodiscard]] bool System::Control::Shutdown() noexcept
{
	bool isOff{false};
	isOff = System::Services::Abort(true);

	return isOff;
}
