for (var i = 1; i <= 100000; i++) {
  var x = i
    .toString(10)
    .split("")
    .map(t => parseInt(t));
  let check = true;
  for (var j = 0; j < x.length; j++) {
    if (x[j]) {
      if (i % x[j]) {
        check = false;
        break;
      }
    }
  }
  /*
  function add(a, b) {
      return a + b;
  }
  */
  if (check && i % x.reduce((a,b) => a+b, 0) == 0) {
    console.log(i);
  }
}
