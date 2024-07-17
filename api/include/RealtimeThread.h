/*******************************************************************************
 * Contents: RealtimeThread class
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _REALTIME_THREAD_H_
#define _REALTIME_THREAD_H_
#include <cstddef>
#include <pthread.h>
#include <Errors.h>
#include <Thread.h>
namespace Api {
	class RealtimeThread : public Interface::Thread {
		public:
			RealtimeThread() = delete;
			explicit RealtimeThread(const int& priority);
			RealtimeThread(const std::size_t& core, const int& priority);
			RealtimeThread(const RealtimeThread&) = default;
			RealtimeThread(RealtimeThread&&) = delete;
			RealtimeThread& operator= (const RealtimeThread&) = default;
			RealtimeThread& operator= (RealtimeThread&&) = default;
			virtual ~RealtimeThread() override;

			[[nodiscard]] virtual bool Prepare(void* (*serviceFunction)(void*)) noexcept override;
			[[nodiscard]] virtual bool Start() noexcept override;

		private:
			cpu_set_t cpuSet{1};
			pthread_t thread{0};
			pthread_attr_t attribute{0};
			int inheritSched{PTHREAD_EXPLICIT_SCHED};
			const int policy{SCHED_FIFO};
			int threadPriority{99};
			enum status {
				ok = 0
			};
	};
}
#endif
