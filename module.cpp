#include <iostream>

#include <torch/csrc/jit/api/compilation_unit.h>
#include <torch/csrc/utils/pybind.h>

namespace py = pybind11;

PYBIND11_MODULE(ptbindrepro, m) {
  std::cerr << "OUR PYBIND11_INTERNALS_ID: " << PYBIND11_INTERNALS_ID
            << std::endl;
  m.def("test_function", [](torch::jit::StrongFunctionPtr function) {
    std::cout << "test_function() called successfully" << std::endl;
  });

  m.def("test_function_cast", [](py::object &object) {
    auto function = py::cast<torch::jit::StrongFunctionPtr>(object);
    std::cout << "cast successful" << std::endl;
    return function;
  });
}
