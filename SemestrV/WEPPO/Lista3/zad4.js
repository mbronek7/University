function createFs(n) {
  var fs = [];

  var _loop = function _loop(i) {
    fs[i] = function () {
      return i; // nowy kontekst
    };
  };

  for (var i = 0; i < n; i++) {
    _loop(i);
  };
  return fs;
}
var myfs = createFs(10);
console.log(myfs[0]()); // zerowa funkcja miała zwrócić 0
console.log(myfs[2]()); // druga miała zwrócić 2
console.log(myfs[7]());


/*
Oryginał:

function createFs(n) { // tworzy tablicę n funkcji
  var fs = []; // i-ta funkcja z tablicy ma zwrócić i
  for (var i = 0; i < n; i++) { // tu należy doistawić let
    fs[i] =
      function () {
        return i;
      };
  };
  return fs;
}

var
Zmienne zadeklarowane za pomocą var działają w kontekście funkcji.
let
Deklaracja zmiennej za pomocą let sprawia, że zmienna działa w kontekście blokowym, np. wewnątrz pętli.
*/

/* Z babel:

function createFs(n) {
  // tworzy tablicę n funkcji
  var fs = []; // i-ta funkcja z tablicy ma zwrócić i

  var _loop = function _loop(i) {
    // tu należy doistawić let
    fs[i] = function () {
      return i;
    };
  };

  for (var i = 0; i < n; i++) {
    _loop(i);
  };
  return fs;
}

*/