from tests.test_upscaler import test_upscaling

import time

st = time.time()
test_upscaling()
print(f'running time: {time.time() - st}')
