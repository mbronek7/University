var Dog = {
  name: undefined,
  'race': undefined,
  set setName(name) {
    this.name = name;
  },
  get getName() {
    return this.name;
  }
}
/*
Pokazać jak do istniejącego obiektu dodać
nowe pole, nową metodę i nową właściwość z akcesorami get i set
*/

console.log("Nowa właściwość z akcesorami get i set:");
console.log(Dog.name);
Dog.name = "fafik";
console.log(Dog.name);
console.log("Nowa metoda:");
Dog.bark = function () {
  return "HAU HAU HAU!"
};
console.log(Dog.bark());

/*
a. Do dodawania nowych składowych do istniejących obiektów można użyć metody
Object.defineProperty
*/

var birthDate = null;
Object.defineProperty(Dog, 'birthDate', {
  get: function () {
    return birthDate
  },
  set: function (newDate) {
    birthDate = newDate
  },
  enumerable: true,
  configurable: true
});

console.log("Add attribute with get&set: ");
console.log(Dog.birthDate);
Dog.birthDate = new Date();
console.log(Dog.birthDate);

/*
Można użyć Object.defineProperty funkcji wykonać następujące czynności:
1) Dodaj nową właściwość do obiektu. Dzieje się tak, gdy obiekt nie jest określona nazwa właściwości.
2) Atrybuty istniejącej właściwości można modyfikować. Dzieje się tak, gdy obiekt jest już określona nazwa właściwości.
*/

// Przykłdd kiedy należy użyć defineProperty do aktualizacji wartośći, ponieważ inaczej się nie da:

const car = {};

Object.defineProperty(car, 'price', {
  value: 42,
  writable: false
});

car.price = 77;

console.log(car.price);