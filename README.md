

References:

* Typeid information not synchronized across shared library boundaries
: https://github.com/pybind/pybind11/issues/912
* https://bugs.llvm.org/show_bug.cgi?id=33542

When compiling my shared library without -fvisibility=hidden, I get a symbol (nm -gDC):

Looking at https://github.com/pybind/pybind11/pull/915 (since moved to detail/internals.h)


libtorch_python.so:
  __pybind11_internals_v4_gcc_libstdcpp_cxxabi1011__

what we compile:
  __pybind11_internals_v4_gcc_libstdcpp_cxxabi1013__


Manually hacking it, the test now passes (but need to do more digging - I doubt this is generically safe):

`-DPYBIND11_BUILD_ABI='"_cxxabi1011"'`

