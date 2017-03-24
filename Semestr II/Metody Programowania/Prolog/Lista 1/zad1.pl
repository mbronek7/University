/*
kot(my_cat).
ryba(_) :- fail.  //predykat fail  zawsze zawodzi i powoduje nawracanie
ptak(_) :- fail.
dzdzownica(_) :- fail.
przyjaciele(me,my_cat).
*/
lubi(X,Y) :- przyjaciele(X,Y).
lubi(X,Y) :- przyjaciele(Y,X).
lubi(X,Y) :- kot(X),ryba(Y).
lubi(X,Y) :- ptak(X),dzdzownica(Y).
jada(my_cat,X) :- lubi(my_cat,X).
