/*******************************************************************************
 * Contents: Semaphore interface
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _SEMAPHORE_H_
#define _SEMAPHORE_H_
namespace Interface {
	class Semaphore {
		public:
			virtual ~Semaphore() = default;
			[[nodiscard]] virtual bool Acquire() = 0;
			[[nodiscard]] virtual bool Release() = 0;
	};
}
#endif
