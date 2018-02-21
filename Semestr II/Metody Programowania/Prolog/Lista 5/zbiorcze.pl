+
+Zad 1
+
+appn([],[]).% przypadek bazowy
+appn([H|T],X) :-% biore 1 element
+	appn(H,T,X).% wywoluje ten z 3
+
+appn([],T,S):-
+	!,appn(T,S). %przypadek bazowy jak pusta jest to wale ten z T i S
+
+appn([H|T1],T2,[H|T]) :-% po kolei elementy z 1 listy laduja w ostatnim buforze
+	appn(T1,T2,T).
+
+Zad 2
+
+flatten(Lista_Wejsciowa,Lista_Splaszczona) :-
+	flatten(Lista_Wejsciowa,[],Lista_tymczasowa), reverse(Lista_tymczasowa,Lista_Splaszczona). %reverse poniewaz odkladam elementy od pierwszego na
+
+flatten([],X,X). % baza rekursji
+flatten([Head|Tail],Lista_Robocza,Lista_Oczekujaca) :-
+	integer(Head),!,   %jak jest liczba to rzucam ja do  listy
+	flatten(Tail,[Head|Lista_Robocza],Lista_Oczekujaca).
+
+	flatten([Head|Tail], Lista_Robocza,Lista_Oczekujaca):-
+	  flatten(Tail, Lista_do_Uzupelnienia, Lista_Oczekujaca), % wywoluje na ogonie ta z dolu przechodzi tu
+	  flatten(Head, Lista_Robocza, Lista_do_Uzupelnienia). % robie ta liste z glowy i jej wynik idzie linijke wyzej
+
+Zad 3
+
+halve(Lista,Lewa,Prawa) :-
+	halve(Lista,Lista,Lewa,Prawa).
+
+halve(R,[],[],R) :- !.% przypadek parzyste
+halve(R,[_],[],R):- !.% przypadek nieparzyste
+
+halve([H|T],[_,_|T2],[H|L],R) :- %to drugie jest rowne liscie wiec zabieram co dwa a z pierwszej o1 element i to co zostanie jest rowne prawej czesci
+	halve(T,T2,L,R).
+
+Zad 4
+
+halve(List,L,R) :-
+	halve(List,List,L,R).
+
+halve(R,[],[],R) :- !.
+halve(R,[_],[],R):- !.
+halve([H|T],[_,_|T2],[H|L],R) :-
+	halve(T,T2,L,R).
+
+%albo 2 albo 1 sie wyczysci
+merge([],X,X) :- !.
+merge(X,[],X) :- !.
+
+merge([H1|T1],[H2|T2],[H1|T]) :- % przpadek H1 jest mniejsze od h2
+	H1 < H2 ,!,
+	merge(T1,[H2|T2],T). % nie dolaczam tego do T i zmniejszam 1 liste
+
+merge([H1|T1],[H2|T2],[H2|T]) :- % dolaczam do T H2
+	merge([H1|T1],T2,T).% zmniejszam 2 liste
+
+
+merge_sort([X],[X]) :- !.% 1 elementowa juz jest posortowana
+merge_sort(In,Out) :-
+	halve(In,L,R), % dziele wejscie na 2 czesci
+	merge_sort(L,L_Sorted),% sortuje ewa strone
+	merge_sort(R,R_Sorted),% sortuje prawa strone
+	merge(L_Sorted,R_Sorted,Out). % lacze te dwa ze soba
+
+Zad 5
+
+%albo 2 albo 1 sie wyczysci
+merge([],X,X) :- !.
+merge(X,[],X) :- !.
+
+merge([H1|T1],[H2|T2],[H1|T]) :- % przpadek H1 jest mniejsze od h2
+	H1 < H2 ,!,
+	merge(T1,[H2|T2],T). % nie dolaczam tego do T i zmniejszam 1 liste
+
+merge([H1|T1],[H2|T2],[H2|T]) :- % dolaczam do T H2
+	merge([H1|T1],T2,T).% zmniejszam 2 liste
+
+	listaPonad(X, 0, X) :-
+		!.
+
+	listaPonad([_|T], Counter, R) :- %funkcja zwraca liste od elementu o 1 wyzszego pozycja od
+		NextCounter is Counter - 1,
+		listaPonad(T, NextCounter, R).
+
+	merge_sort(List, Result) :-
+		length(List, ListLength), % dlugosc listy
+		merge_sort(List, ListLength, Result).
+
+	merge_sort([H|_], 1, [H]) :-!.  %jak mam posortowac 1 element to koncze
+
+merge_sort(List, Ilosc, Result) :-
+		PierwszaPolowa is Ilosc // 2,
+		DrugaPolowa is Ilosc - PierwszaPolowa,
+		listaPonad(List, PierwszaPolowa,ListaDrugaPolowa),
+		merge_sort(List, PierwszaPolowa, SortedLeft),
+		merge_sort(ListaDrugaPolowa, DrugaPolowa, SortedRight),
+		merge(SortedLeft, SortedRight, Result).
+
+Zad 6
+
+listajednoelementowych([],[]).
+listajednoelementowych([H|T],[[H]|P]):-
+	listajednoelementowych(T,P).
+
+	%albo 2 albo 1 sie wyczysci
+	merge([],X,X) :- !.
+	merge(X,[],X) :- !.
+
+	merge([H1|T1],[H2|T2],[H1|T]) :- % przpadek H1 jest mniejsze od h2
+		H1 < H2 ,!,
+		merge(T1,[H2|T2],T). % nie dolaczam tego do T i zmniejszam 1 liste
+
+	merge([H1|T1],[H2|T2],[H2|T]) :- % dolaczam do T H2
+		merge([H1|T1],T2,T).% zmniejszam 2 liste
+
+		merge_sort(X,Y):-
+			listajednoelementowych(X,Listajedno), % tworze liste jednoelementowych
+			sort_pom(Listajedno,Y).
+
+		sort_pom(Listajedno,Wynik):-
+			sort_pom(Listajedno,Wynik,[]).
+
+		sort_pom([],S,[S]):-!. % przypadek bazowy jak w ostaniej bedzie jeden element to koncze
+
+		sort_pom([S],W,A):-  % jak zostalo nieparzyste ilosc razy to z konca rzucam na poczatek
+			sort_pom([S|A],W,[]).
+
+		sort_pom([],W,A):- % wywoluje sort_pom z tym co zostalo na koncu z list 2 ele na 4 itp
+			sort_pom(A,W,[]).
+
+		sort_pom([H1,H2|Listajedno],W,A):-  % pobieram dwa elementy  z tej listy
+			merge(H1,H2,X),  % lacze je
+			sort_pom(Listajedno,W,[X|A]). % wywoluje sorta na tym co zostalo do ostatniej loduje mergowane el
+
+Zad 7
+
+
+split([], _, [], []):- !. % tu koncze
+
+split([E|List], Med, Small, [E|Big]):-
+  E >= Med, % jak jest wieksze to laduje w big
+  !,
+  split(List, Med, Small, Big).
+
+split([E|List], Med, [E|Small], Big):- % przeciwny przypadek
+  split(List, Med, Small, Big).
+
+qsort(List, Sorted):-
+  qsort(List, Sorted, []).
+
+qsort([], Sorted, Sorted).% pusta z przodu przypadek bazowy dla rekursji
+
+qsort([E|Tail], Sorted, Acc):-
+  split(Tail, E, Small, Big),
+  qsort(Big, NextAcc, Acc),
+  qsort(Small, Sorted, [E|NextAcc]).
