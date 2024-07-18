/*******************************************************************************
 * Contents: Mutex interface
 * Author: Dawid Blom
 * Date: October 22, 2023
 *
 * Note:
 ******************************************************************************/
#ifndef _MUTEX_H_
#define _MUTEX_H_
namespace Interface {
	class Mutex {
		public:
			virtual ~Mutex() = default;
			[[nodiscard]] virtual bool Lock() = 0;
			virtual bool Unlock() = 0;
	};
}
#endif
