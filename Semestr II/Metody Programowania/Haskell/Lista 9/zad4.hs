fib :: Int -> Int

fib n = f !! (n + 1) where
        f = 1:1:zipWith (+) f (tail f)
