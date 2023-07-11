from tests.test_upscaler import test_upscaling

import time

st = time.time()
test_upscaling()
print(f'running time: {time.time() - st}')

# 17103.15162587166 (2, 8K)
# 4100.953718185425 (2, 4K)
#
