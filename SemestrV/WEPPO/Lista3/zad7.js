function* fibGen() {
  var f1 = 0,
    f2 = 1;
  while (true) {
    let temp = f1;
    f1 = f2;
    f2 = temp + f1;
    yield temp;
  }
}

function fib() {
  var f1 = 0,
    f2 = 1;
  return {
    next: function () {
      var temp = f1;
      f1 = f2;
      f2 = temp + f1;
      return {
        value: temp,
        done: false
      }
    }
  }
}

console.log("Wersja z Generatorem");
for (var i of fibGen()) {
  if (i > 100) break;
  console.log(i);
}
console.log("``````````");
var _it = fibGen();
for (var _result; _result = _it.next(), !_result.done;) {
  if (_result.value > 100) break;
  else {
    console.log(_result.value);
  }
}
console.log("Wersja z Iteratorem");
var _it = fib();
for (var _result; _result = _it.next(), !_result.done;) {
  if (_result.value > 100) break;
  else {
    console.log(_result.value);
  }
}
console.log("``````````");
for (var i of fibGen()) {
  if (i > 100) break;
  console.log(i);
}