function sum(...args) {
  let sum = 0;
  args.forEach(_ => sum += _);
  return sum;
}

console.log(sum(1, 2, 3, 4, 5));