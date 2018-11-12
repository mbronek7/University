function* fib() {
  var f1 = 0,
    f2 = 1;
  while (true) {
    let temp = f1;
    f1 = f2;
    f2 = temp + f1;
    yield temp;
  }
}

/*
function* take(it, top) {
... yield ...
}
// zwróć dokładnie 10 wartości z potencjalnie
// "nieskończonego" iteratora/generatora
for (let num of take( fib(), 10 ) ) {
console.log(num);
}
*/

function* take(it, top) {
  var i = 0;
  do {
    _ = it.next();
    yield _.value
  } while (++i < top);
}

for (let num of take(fib(), 10)) {
  console.log(num);
}