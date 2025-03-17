---
title: Code with syntax highlighting
lang: en-US
...

``` c {.numberLines}
#include <stdio.h>

int main(void) {
  printf("Hello world!");
}
```

``` haskell {.numberLines}
-- | Inefficient quicksort in haskell.
qsort :: (Enum a) => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
```
