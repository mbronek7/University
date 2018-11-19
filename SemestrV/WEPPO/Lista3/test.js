function fac(n) {
  if (n > 0) {
    return n * memofac2(n - 1);
  } else {
    return 1;
  }
}

function memoize(fn) {
  var cache = {};
  return function (n) {
    if (n in cache) {
      return cache[n]
    } else {
      var result = fn(n);
      cache[n] = result;
      return result;
    }
  }
}
var memofac2 = memoize(fac);
console.log(memofac2(5));
console.log(memofac2(6));