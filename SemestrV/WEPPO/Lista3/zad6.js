/*
Oryginał:
function createGenerator() {
  var _state = 0;
  return {
    next: function () {
      return {
        value: _state,
        done: _state++ >= 10
      }
    }
  }
}
*/
function createGenerator(n) {
  var _state = 0;
  return {
    next: function () {
      return {
        value: _state,
        done: _state++ >= n
      }
    }
  }
}

var foo = {
  [Symbol.iterator]: createGenerator.bind(this,20)
};
for (var f of foo)
  console.log(f);

console.log("\n```````````````````````````````");
var foo1 = {
  [Symbol.iterator]: createGenerator.bind(this,10)
};
for (var f of foo1)
  console.log(f);