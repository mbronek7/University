/* Funktory do budowania klauzul */

:- op(200, fx, ~).
:- op(500, xfy, v).

/* Główny program: main/1. Argumentem jest atom będący nazwą pliku
 * z zadaniem. Przykład uruchomienia:
 *    ?- main('zad125.txt').
 * Plik z zadaniem powinien być plikiem tekstowym, na którego
 * początku znajduje się lista klauzul zbudowanych za pomocą funktorów
 * v/2 i ~/1 (szczegóły znajdują się w opisie zadania). Listę zapisujemy
 * w notacji prologowej, tj. rozdzielając elementy przecinkami
 * i otaczając listę nawiasami [ i ]. Za nawiasem ] należy postawić
 * kropkę. Wszelkie inne znaki umieszczone w pliku są pomijane przez
 * program (można tam umieścić np. komentarz do zadania).
 */



 %% klauzula niepusta
 empty([[],[]]).
 not_empty(A) :- not(empty(A)).


 %% pierwszy element listy
 first([H|_],H).

 %% czy predykat pozytywny czy negatywny
 negative(~_).
 positive(A) :- not(negative(A)).

 %% zmienia literal z pozytywnego na negatywny i vice versa
 change(~A,A) :- !.
 change(A,~A).

 %% pomocnicze bo sortuje
 parse(I,O) :- parse_clause(I,T), sort(T,O).

 %% parsuje jedna klauzule do odpowidniej pojedynczej postaci
 parse_clause(A v R, [A|X]) :- parse_clause(R,X),!.
 parse_clause(A,[A]).

 %% zamienia [ p v q v q , p , ~q v q ] na [ [p,q], [p], [q,~q] ]
 parse_clauses( [H|T], [A|R] ) :- parse(H,A), parse_clauses(T,R).
 parse_clauses( [], [] ).

 %% two_clauses zamienia klauzule na postać dwulistową.
 two_clauses([],[[],[]]):-!.
 two_clauses([H|T],[ [H|T2], N]):-
   positive(H), two_clauses(T,[T2,N]).
 two_clauses([H|T],[P,[H2|T2]]):-
   negative(H), change(H,H2), two_clauses(T,[P,T2]).

 %% parsuje liste klauzul do postaci dwulistowej
 parse_two_clauses( [H|T], [A|R] ) :-
 	parse(H,C),
 	two_clauses(C,A),
 	parse_two_clauses(T,R),!.
 parse_two_clauses( [], [] ).

 %% numeruje liste
 enum([], _, Akk, Res) :- reverse(Akk, Res).
 enum([H|T], N, Akk, Res) :- N2 is N + 1, enum(T, N2, [N-H|Akk], Res).

 %% tworzy liste asocjacyjna klauzul
 create_assoc(List,Assoc) :-
   parse_two_clauses(List,Temp), enum(Temp,1,[],Lol), list_to_assoc(Lol,Assoc).

 %% z listy zwyklych klauzul robi liste asocjacyjna
 clauses_assoc_list(Clauses,Assoc) :-
 	%% parse_two_clauses(Clauses,A),
 	create_assoc(Clauses,Assoc).
 %%
 %%
 %%

 %% neguje wszystkie literały w liscie
 negation([],[]).
 negation([H|T],[~H|T1]) :- negation(T,T1).

 %% sprowadza do listy literalow
 unparse1([P,N],R) :- negation(N,Nt), append(P,Nt,R).

 %% sprowadza liste literalow do normalnej klauzuli
 unparse2([], []).
 unparse2([H|T], Klauzula) :-
 unparse2(T, Klauzula2),
 Klauzula2 = [],
 !,
 Klauzula = H.

 unparse2([H|T], Klauzula) :-
 unparse2(T,Klauzula2),
 Klauzula = H v Klauzula2.

 %% sprwadza tw_clause do normalnej klauzuli
 unparse(Two_Clause,Clause) :- unparse1(Two_Clause,Temp), unparse2(Temp, Clause).

 %%
 %%
 %%

 %% tworzy rezolwente 2 klauzul
 resolve([P1,N1], [P2,N2], [Pr,Nr]):-
   ord_intersection(P1,N2,I1),
   ord_intersection(N1,P2,I2),
   ord_union(I1,I2,U),
   length(U,L),
   L is 1,
   first(U,E),
   ord_del_element(P1,E,P1temp),
   ord_del_element(P2,E,P2temp),
   ord_del_element(N1,E,N1temp),
   ord_del_element(N2,E,N2temp),
   ord_union(P1temp,P2temp,Pr),
   ord_union(N1temp,N2temp,Nr).

 append_on_proof_list(Two_Clause,Origin,In,Out) :-
     unparse(Two_Clause,Clause),
     not(  member( (Clause, _),In )  ),
     append(In,[(Clause, Origin)],Out).
 append_on_proof_list(_,_,In,In).


 %% !!! NOWE
 put_on_assoc(Length,Length_New,Assoc,C,Assoc_New):-
   assoc_to_values(Assoc,Clauses),
   not( member(C,Clauses)),
   Length_New is Length + 1,
   put_assoc(Length_New,Assoc,C,Assoc_New).
 put_on_assoc(Length,Length,Assoc,C,Assoc):-
   assoc_to_values(Assoc,Clauses),
   member(C,Clauses).



 put([],[]).
 put([H|T],[(H,axiom)|Rest]) :-
 	put(T,Rest).


 %% nastepna kombinacja
 next(Ns,Ms,N,M) :-
     Ns is  Ms + 1,
     N is Ns + 1,
     M is 1,!.
 next(Ns,Ms,Ns,M) :-
     Ns > Ms + 1,
     M is Ms + 1,!.

 %% gdy nie da sie zrezolwentowac
 prove1(Assoc,Proof,N,M,Length,ProofAcc) :-
     N =< Length,
     M =< Length,
     get_assoc(N,Assoc,A),
     get_assoc(M,Assoc,B),
     not(resolve(A,B,_)),
     next(N,M,Nn,Mn),
     prove1(Assoc,Proof,Nn,Mn,Length,ProofAcc).

 %% da sie zrezolwentowac
 prove1(Assoc,Proof,N,M,Length,ProofAcc) :-
     N =< Length,
     M =< Length,
     get_assoc(N,Assoc,A),
     get_assoc(M,Assoc,B),
     resolve(A,B,C),
     not_empty(C),
     %% LengthNew is Length + 1,
     %% put_assoc(LengthNew,Assoc,C,Assoc_New),
     put_on_assoc(Length,LengthNew,Assoc,C,Assoc_New),
     append_on_proof_list(C,(N,M),ProofAcc,ProofOut),
     next(N,M,Nn,Mn),
     %% LengthNew is Length + 1,
     prove1(Assoc_New,Proof,Nn,Mn,LengthNew,ProofOut).

 %% da sie i klauzula pusta
 prove1(Assoc,Proof,N,M,Length,ProofAcc):-
     N =< Length,
     M =< Length,
     get_assoc(N,Assoc,A),
     get_assoc(M,Assoc,B),
     resolve(A,B,C),
     empty(C),
     append_on_proof_list(C,(N,M),ProofAcc,Proof).
     %% LengthNew is Length + 1,
     %% put_assoc(LengthNew,Assoc,C,Assoc_New).

 prove(Clauses,Proof):-
     %% clauses_assoc_list(Clauses,Assoc),
     create_assoc(Clauses,Assoc),
     max_assoc(Assoc,Length,_),
     put(Clauses,ProofAcc),
     prove1(Assoc,Proof,2,1,Length,ProofAcc).
