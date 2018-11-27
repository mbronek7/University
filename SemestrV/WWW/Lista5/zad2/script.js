$(function () {
  var dialog, form,
    name = $("#name"),
    surname = $("#surname"),
    city = $("#city"),
    zipcode = $("#zipcode"),
    birth = $("#birth"),
    allFields = $([]).add(name).add(surname).add(city).add(zipcode).add(birth),
    tips = $(".validateTips");

  function updateTips(t) {
    tips
      .text(t)
      .addClass("ui-state-highlight");
    setTimeout(function () {
      tips.removeClass("ui-state-highlight", 1500);
    }, 500);
  }

  function checkLength(o, n, min, max) {
    if (o.val().length > max || o.val().length < min) {
      o.addClass("ui-state-error");
      updateTips("Długość " + n + " musi być pomiędzy " +
        min + " a " + max + ".");
      return false;
    } else {
      return true;
    }
  }

  function checkRegexp(o, regexp, n) {
    if (!(regexp.test(o.val()))) {
      o.addClass("ui-state-error");
      updateTips(n);
      return false;
    } else {
      return true;
    }
  }

  function addUser() {
    var valid = true;
    allFields.removeClass("ui-state-error");
    valid = valid && checkLength(name, "Imienia", 3, 40);
    valid = valid && checkLength(surname, "Nazwiska", 3, 40);
    valid = valid && checkLength(city, "Miasta", 3, 40);
    valid = valid && checkLength(zipcode, "Kodu pocztowego", 6, 6);
    valid = valid && checkRegexp(name, /[A-ZĄĘŁŃÓŚŹŻ][a-ząćęłńóśźż]*$/i, "Imię musi zawierać znaki z przedziału  a-z lub spację oraz musi zaczynać się literą!");
    valid = valid && checkRegexp(surname, /[A-ZĄĘŁŃÓŚŹŻ][a-ząćęłńóśźż]*$/i, "Nazwisko  musi zawierać znaki z przedziału a-z lub spacji oraz musi zaczynać się literą!");
    valid = valid && checkRegexp(zipcode, /^[0-9]{2}-[0-9]{3}/i, "Kod pocztowy ma format xx-xxx i składa się z cyfr i myślnika!");
    valid = valid && checkRegexp(birth, /^[0-9]{2}-[0-9]{2}-[1-2]{1}[0-9]{1}[0-9]{1}[0-9]{1}/i, "Data urodzin w formacie DD-MM-RRRR!");
    if (valid) {
      $("#users tbody").append("<tr>" +
        "<td>" + name.val() + "</td>" +
        "<td>" + surname.val() + "</td>" +
        "<td>" + city.val() + "</td>" +
        "<td>" + zipcode.val() + "</td>" +
        "<td>" + birth.val() + "</td>" +
        "<td>" + "<button type='button'  class='removebutton' title='Usuń'>X</button>" + "</td>" +
        "</tr>");
      $(this).dialog("close");
    }
    return valid;
  }
  dialog = $("#dialog-form").dialog({
    autoOpen: false,
    height: 400,
    width: 550,
    modal: true,
    buttons: {
      "Dodaj": addUser,
      "Anuluj": function () {
        dialog.dialog("close");
      }
    },
    close: function () {
      form[0].reset();
      allFields.removeClass("ui-state-error");
    }
  });
  form = dialog.find("form").on("submit", function (event) {
    event.preventDefault();
    addUser();
  });
  $("#create-user").button().on("click", function () {
    dialog.dialog("open");
  });
  $("#birth").datepicker({
    dateFormat: 'dd-mm-yy'
  });
  $(document).on('click', 'button.removebutton', function () {
    $("#dialog-remove").dialog('open');
    $(this).closest('tr').addClass('toRemove');
    return false;
  });
  $("#dialog-remove").dialog({
    modal: true,
    bgiframe: true,
    width: 210,
    height: 150,
    autoOpen: false,
    buttons: {
      "Tak": function () {
        $(".toRemove").remove();
        $(this).dialog("close");
      },
      "Nie": function () {
        $(".toRemove").removeClass("toRemove");
        $(this).dialog("close");
      }
    }
  });
});