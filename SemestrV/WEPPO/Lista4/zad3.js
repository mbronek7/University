var Foo = function (foo) {
};

Foo.prototype.Bar = (function () {
  function Qux() {
    return "CALL OF PRIVATE FUNCTION"
  }

  return function () {
    return "PUBLIC " + Qux()

  };
})();



var myObject = new Foo('bar');
console.log(myObject.Bar())
//console.log(myObject.Qux())