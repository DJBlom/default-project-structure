/*******************************************************************************
 * Contents: Thread interface
 * Author: Dawid Blom
 * Date: October 1, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _THREAD_H_
#define _THREAD_H_
namespace Interface {
	class Thread {
		public:
			virtual ~Thread() = default;
			[[nodiscard]] virtual bool Prepare(void* (*serviceFunction)(void*)) = 0;
			[[nodiscard]] virtual bool Start() = 0;
	};
}
#endif
