fib :: Int -> Int

fib 0 = 0
fib n = f !! (n - 1) where
        f = 1:1:zipWith (+) f (tail f)
