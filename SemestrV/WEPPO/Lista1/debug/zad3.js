for (var i = 2; i <= 100000; i++) {
    let check = true;
    for (var j = 2; j * j <= i; j++) {
        if (!(i % j)) {
            check = false;
            break;
        }

    }
    (check) ? console.log(i) : "";
}
