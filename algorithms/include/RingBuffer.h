/*******************************************************************************
 * Contents: RingBuffer class
 * Author: Dawid Blom
 * Date: October 23, 2023
 *
 * Methods:
 * - Insert(data); return void, and ensures that the item is added to the list
 * - Retrieve(data); return false if list is empty, true otherwise.
 *                   the argument "data" holds the object returned
 * - Empty(); return false if list is empty, true otherwise
 * - operator==; return true if objects are equal, false otherwise
 ******************************************************************************/
#ifndef _RING_BUFFER_H_
#define _RING_BUFFER_H_
#include <cstdint>
namespace Algorithm {
    template<class type, std::size_t size>
	class RingBuffer {
		public:
            RingBuffer() = default;
            RingBuffer(const RingBuffer& rb) = default;
            RingBuffer& operator= (const RingBuffer& rb) = default;
            RingBuffer(RingBuffer&& rb) = default;
            RingBuffer& operator= (RingBuffer&& rb) = default;
            virtual ~RingBuffer() = default;

            virtual void Insert(const type& data) noexcept
            {
                this->buffer[this->tail] = data;
                if (BufferIsFull())
                {
                    ManageHeadIndex();
                }
                ManageTailIndex();
            }

            [[nodiscard]] virtual bool Retrieve(type& data) noexcept
            {
                bool success{true};
                data = this->buffer[this->prevhead];
                if (BufferIsEmpty())
                {
                    success = false;
                }
                else
                {
                    ManageHeadIndex();
                }

                return success;
            }

            [[nodiscard]] virtual bool Empty() noexcept
            {
                return BufferIsEmpty();
            }

            [[nodiscard]] bool operator== (const RingBuffer& rb) const noexcept //GCOV_EXCL_START
            {
                return (*this == rb);
                //GCOV_EXCL_STOP
            }

        private:
            void ManageHeadIndex()
            {
                this->prevhead = this->head;
                this->head = (this->head + Index::next) % this->max;
            }

            void ManageTailIndex()
            {
                this->prevtail = this->tail;
                this->tail = (this->tail + Index::next) % this->max;
            }

            [[nodiscard]] bool BufferIsFull()
            {
                return (this->head == ((this->tail + Index::next) % this->max));
            }

            [[nodiscard]] bool BufferIsEmpty()
            {
                return (this->head == this->tail);
            }

		private:
            int head{1};
            int tail{1};
            int prevhead{1};
            int prevtail{1};
            std::uint16_t max{size};
            type buffer[size]{};
            enum Index : std::uint16_t {
                next = 1
            };
	};
}
#endif
