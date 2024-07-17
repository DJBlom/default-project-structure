/*******************************************************************************
 * Contents: Control class
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _CONTROL_H_
#define _CONTROL_H_
#include <sched.h>
#include <Errors.h>
#include <Services.h>
#include <RealtimeThread.h>
namespace System {
	constexpr int maxPriority{99};
	class Control {
		public:
			Control() = delete;
			explicit Control(const pid_t& pid);
			Control(const Control&) = delete;
			Control(Control&&) = delete;
			Control& operator= (const Control&) = delete;
			Control& operator= (Control&&) = delete;
			~Control() = default;

			[[nodiscard]] bool Start() noexcept;
			[[nodiscard]] bool Shutdown() noexcept;

		private:
			int priority{System::maxPriority};
			bool shutdown{false};
			const int policy{SCHED_FIFO};
			Api::RealtimeThread sequencer{this->priority - 1};
			Api::RealtimeThread input{this->priority - 2};
			Api::RealtimeThread processData{this->priority - 3};
			Api::RealtimeThread output{this->priority - 4};
			enum status {
				ok = 0
			};
	};
}
#endif
