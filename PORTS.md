# Python equivalent

No single PyPI package matches `NDcell2mat`'s exact scope: an N-dimensional container of ragged numeric arrays, padded to one dense array with a chosen fill value. `itertools.zip_longest` combined with `numpy` covers the common one- and two-dimensional cases with no dependency beyond NumPy; see [`research/python-equivalents.md`](research/python-equivalents.md) for the full survey and scoring behind this recommendation.

```python
import numpy as np
from itertools import zip_longest

def pad_ragged(rows, fill=np.nan):
    return np.array(list(zip_longest(*rows, fillvalue=fill))).T
```

```python
>>> pad_ragged([[0], [1, 2, 3], [4, 5]])
array([[ 0., nan, nan],
       [ 1.,  2.,  3.],
       [ 4.,  5., nan]])
```

For a container shape beyond a flat list of 1-D sequences, write the loop directly, mirroring `NDcell2mat`'s own approach:

```python
import numpy as np

def pad_nd(cells, shape, fill=np.nan):
    n = max(np.asarray(c).size for c in cells.flat)
    out = np.full(shape + (n,), fill, dtype=float)
    for idx, c in np.ndenumerate(cells):
        flat = np.asarray(c).ravel()
        out[idx][: flat.size] = flat
    return out
```

Neither recipe is a packaged, importable equivalent of `NDcell2mat`; both are two functions a user pastes and adapts.
