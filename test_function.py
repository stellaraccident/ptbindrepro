# import sys
# import ctypes
# flags = sys.getdlopenflags()
# sys.setdlopenflags(flags | ctypes.RTLD_GLOBAL)

import ptbindrepro
import torch

@torch.jit.script
def add3(t0, t1, t2):
  return t0 + t1 + t2


print(dir(add3))
ptbindrepro.test_function_cast(add3)
ptbindrepro.test_function(add3)
