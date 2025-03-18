---
title: Code with syntax highlighting
lang: en
...

``` c {.number-lines}
#include <stdio.h>

int main(void) {
  printf("Hello world!");
}
```

``` haskell {.number-lines}
-- | Inefficient quicksort in haskell.
qsort :: (Enum a) => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
```
