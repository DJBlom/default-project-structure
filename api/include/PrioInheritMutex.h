/*******************************************************************************
 * Contents: PrioInheritMute class
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _PRIO_INHERIT_MUTEX_H_
#define _PRIO_INHERIT_MUTEX_H_
#include <pthread.h>
#include <Errors.h>
#include <Mutex.h>
namespace Api {
	class PrioInheritMutex : public Interface::Mutex {
		public:
			PrioInheritMutex();
			PrioInheritMutex(const PrioInheritMutex&) = default;
			PrioInheritMutex(PrioInheritMutex&&) = default;
			PrioInheritMutex& operator= (const PrioInheritMutex&) = default;
			PrioInheritMutex& operator= (PrioInheritMutex&&) = default;
			virtual ~PrioInheritMutex() override;

			[[nodiscard]] virtual bool Lock() noexcept override;
			[[nodiscard]] virtual bool Unlock() noexcept override;

		private:
			pthread_mutex_t mutex;
			pthread_mutexattr_t attribute;
			enum status {
				ok = 0
			};
	};
}
#endif
