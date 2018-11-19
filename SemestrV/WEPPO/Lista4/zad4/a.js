var ClassB = require("./b");

var ClassA = function() {
    this.print = new ClassB();
    this.name = "John Doe"
}

var a = new ClassA();

module.exports = a;