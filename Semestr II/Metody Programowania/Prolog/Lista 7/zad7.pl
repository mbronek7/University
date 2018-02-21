:-arithmetic_function(!/1). % predykat ktory definuje deklaruje jako ! dzialanie arytmetyczne
:-op(150,yf,!). % postfix  i 150 bo nizej tym wiekszy a 200 maja dodawania itp.



!(0,1):-!.  % zero silnia to zero
!(N,Res):-  % silnia z n to
	N > 0,  % jak n wieksze od zera
	Nm is N - 1, % zmniejszam N o jeden i wywoluje silnie rekurencja
	!(Nm,Resm), % tu wywoluje
	Res is Resm * N.  % no i mnozenie

:-arithmetic_function('!!'/1).  % iloczyn liczb nieparzystych od 1 do tej liczby
:-op(150,yf,'!!'). %postfix


'!!'(N,Res) :-  % wywoluje ogolnie
	'!!'(N,1,Res).

'!!'(1,Res,Res):-!.  % albo zejde do 1
'!!'(2,Res,Res):-!.   % albo do 2
'!!'(N, Acc, Res):-
	1 is N mod 2,!,  % dla nieparzystej liczby na wejsciu
	Accn is Acc * N,  % jak jest nieparzysta to mnoze Acc obezny przez nia i wiola
	Nnew is N - 2,  % nowa nieparzysta bedzie o 2 mniejsza
	'!!'(Nnew,Accn,Res).

'!!'(N, Acc, Res):-
	Accn is Acc * (N - 1),
	Nnew is N - 3,  % N -3 zeby zejsc na nieparzyste
	'!!'(Nnew,Accn,Res).
