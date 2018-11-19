var ClassB = function () {}

ClassB.printName = function() {
  console.log(`I am in module B my name is ${a.name}`);
}

module.exports = ClassB;

var a = require("./a");