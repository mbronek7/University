window.onload = function load() {
  document.getElementById('form').onsubmit = checkForm;
}

function checkForm() {
  var check = true;
  if (!checkField('pesel')) {
    check = false;
  }
  if (!checkField('email')) {
    check = false;
  }
  if (!checkField('date')) {
    check = false;
  }
  if (!checkField('numer')) {
    check = false;
  }
  if(!check){
    alert('Niepoprawne dane');
    return false;
  }
  alert('Wysłano');
  return true;
}

var regexes = {
  pesel: /[0-9]{11}/,
  date: /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/,
  email: /^[0-9a-zA-Z_.-]+@[0-9a-zA-Z.-]+\.[a-zA-Z]{2,3}$/,
  numer: /[0-9]{26}/
}

function checkField(field_name) {
  var field = document.getElementById(`${field_name}`);
  var regex = regexes[`${field_name}`];
  if (regex.test(field.value) == false) {
    field.style.border = "2px solid #FF0000";
    return false;
  }
  field.style.border = "2px solid #00E600";
}