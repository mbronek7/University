function fib(n) {
  if (n == 0)
    return 0;
  if (n == 1)
    return 1;
  return fib(n - 1) + fib(n - 2);
}

function memoizefib() {
  var cache = {};

  return fibonacci = function (n) {
    if (n in cache) {
      return cache[n];
    } else {
      var result = fibonacci(n - 1) + fibonacci(n - 2);
      cache[n] = result;
      return result;
    }
  }
}


console.time("memo");
memoizefib(40);
console.timeEnd("memo");
console.time("rec");
fib(40);
console.timeEnd("rec");