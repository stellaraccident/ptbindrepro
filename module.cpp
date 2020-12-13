#include <iostream>

#include <torch/csrc/utils/pybind.h>
#include <torch/csrc/jit/api/compilation_unit.h>

namespace py = pybind11;

PYBIND11_MODULE(ptbindrepro, m) {
  m.def("test_function", [](torch::jit::StrongFunctionPtr function) {
    std::cout << "test_function() called successfully" << std::endl;
  });
}
