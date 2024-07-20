#ifndef _HELLO_WORLD_H_
#define _HELLO_WORLD_H_
#include <Feature.h>
#include <RingBuffer.h>
namespace Feature {
    class Helloworld : public Interface::Feature {
        public:
            [[nodiscard]] virtual bool Input() noexcept override;
            [[nodiscard]] virtual bool Process() noexcept override;
            [[nodiscard]] virtual bool Output() noexcept override;
        private:
            Algorithm::RingBuffer<int, 5> inputBus;
            Algorithm::RingBuffer<int, 5> processBus;
            Algorithm::RingBuffer<int, 5> outputBus;
    };
}
#endif
