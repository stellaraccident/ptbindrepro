import torch
import ptbindrepro

@torch.jit.script
def add3(t0, t1, t2):
  return t0 + t1 + t2


ptbindrepro.test_function(add3)
