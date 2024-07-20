#ifndef _FEATURE_H_
#define _FEATURE_H_
namespace Interface {
    class Feature {
        public:
            virtual ~Feature() = default;
            [[nodiscard]] virtual bool Input() = 0;
            [[nodiscard]] virtual bool Process() = 0;
            [[nodiscard]] virtual bool Output() = 0;
    };
}
#endif
