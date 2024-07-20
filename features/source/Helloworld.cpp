#include <Helloworld.h>
#include <iostream>

 
[[nodiscard]] bool Feature::Helloworld::Input() noexcept //GCOV_EXCL_START
{
    bool success{false};
    if (this->inputBus.Insert(1))
        success = true;
    return success;
    //GCOV_EXCL_STOP
}

[[nodiscard]] bool Feature::Helloworld::Process() noexcept //GCOV_EXCL_START
{
    int processItem{0};
    bool success{false};
    while (!this->inputBus.Empty())
    {
        if (this->inputBus.Retrieve(processItem))
        {
            ++processItem;
            if (this->processBus.Insert(processItem))
                success = true;
        }
    }

    return success;
    //GCOV_EXCL_STOP
}

[[nodiscard]] bool Feature::Helloworld::Output() noexcept //GCOV_EXCL_START
{
    int outputItem;
    bool success{false};
    if (this->processBus.Retrieve(outputItem))
    {
        success = true;
        std::cout << "Sending: " << outputItem << " over tcp socket 1\n";
    }

    return success;
    //GCOV_EXCL_STOP
}
