% Definiujemy moduł zawierający rozwiązanie.
% Należy zmienić nazwę modułu na {imie}_{nazwisko} gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(michal_bronikowski, [resolve/4, prove/2]).

:- op(200, fx, ~).
:- op(500, xfy, v).

negation(~X, X):-!.   % predykat do negowania zmiennych
negation(X, ~X).

change(~X,X):-!.  % predykat do zamiany zmiennej do postaci bez negacji
change(X,X).

create_clause([],[]):-!.  % predykat do tworzenia klazul z listy zawierajacej zmienne
create_clause([X],X):-!.
create_clause([H|T],X):-
  create_clause(T,X2),
  X = H v X2.

% predykaty z 1 pracowni :
is_it_a_variable(X) :- atom(X).
is_it_a_variable(~X) :- atom(X).

take_every_variable_from_one_clause([],[]) :- !.
take_every_variable_from_one_clause(v(X,Y),T) :- take_every_variable_from_one_clause(X,TF),!, take_every_variable_from_one_clause(Y,TE),!, append(TF,TE,T).
take_every_variable_from_one_clause(~X,[~X]) :- is_it_a_variable(X),!.
take_every_variable_from_one_clause(X,[X]) :- is_it_a_variable(X),!.

% koniec predykatow z 1 pracowni

list(H,X):-take_every_variable_from_one_clause(H,Y),sort(Y,X). % predykat tworzacy liste zmiennych z klauzuli

list_clauses([],[]):-!.    % predykat tworzac liste list zmiennych z klauzul
list_clauses([H|T],[Y|X]):-
          list(H,Y),
  list_clauses(T,X).

  new_number(Number,NewNumber):- % predykat zwieksza o 1 element number potrzebny w predykacie find_proof jak znajde kolejny element dowodu to chce zeby był on olejny w zbiorze czyli np.6, żeby póżniej jak z niego skorzystam łatwo było można stwierdzić ze skorzystałem np. z 7 i 4 żeby uzyskać 9.
    NewNumber is Number + 1.

first_and_last_element([L],L,[]):-!.    % predykat pobierajacy pierwszy element z listy trzecia zmienna unifikuje sie z reszta listy wejsciowej(bez 1 elementu)
first_and_last_element([H|T],H,T).
first_and_last_element([_|T], X, Y) :-
    first_and_last_element(T, X, Y).

axiom_list([],[],_) :-!.   % predykat tworzacy liste zawierajaca wszystkie klauzule z wejscia razem z axiom tzn postaci (zmienna,ktora_na_liscie,axiom) N reprezentuje ilosc klauzul
axiom_list(H,X,N):-
  axiom_list(H,1,X,[]),
  length(X,N).

axiom_list([], _, RESULT, RESULT) :-!.
axiom_list([H|T],N,RESULT,Acumulator) :-
  new_number(N,NEWN),
  axiom_list(T,NEWN,RESULT,[[H,N,axiom]| Acumulator]).

%predykat axiom_list tworzy liste zawierajaca zmienne postaci zmienna,ktora_na_liscie,axiom w celu łatwego zidentyfikowania jak przebiegał dowod tzn ze rezolucja była np,wzgledem 1 i 3 klauzuli z wejscia

find_numer_of_current_clause(Clause, Proof, Number) :-  %predykat bierze numer klazuli ktora jest uzyta w dowodzie (prove) i doklada ją do listy Proof
  first_and_last_element(Proof, [Clause, Number, _], _), !.

turnorder(Element,A,B,X,Y):- % predykat potrzebny przy wypisywaniu wyniku zeby wynik był postaci (rezolwenta,zmienna,klazula_zpozytywnm_wystapieniem_zmiennej,klauzula_z_negatywnym_wystapieniem_zmiennej)
  (memberchk(Element,A) -> X = A,Y = B; Y = A, X = B).   % zamieniam kolejnosc w zaleznosci od wystepowania elementu element jest juz po zastosowaniu predykatu change wiec na pewno nie zawiera negacji

%resolve(zmienna,klauzula1,klauzula2,wynik)
resolve(Element,Clause1,Clause2,Result):-
  list(Clause1,Lista1),
  list(Clause2,Lista2),
  ord_del_element(Lista1,Element,WynikowaListazPierwszej), %ord_del_element uzyty bo list juz sortuje i tak jest szybciej niz uzycie select czy selectchk
  negation(Element,NegationofElement),   %neguje element zeby usunac z 2 klazuli jego negacje
  ord_del_element(Lista2,NegationofElement,WynikowaListazDrugiej),
  append(WynikowaListazDrugiej,WynikowaListazPierwszej,TEMP), %lacze dwie listy wynikowe po usunieciu odpowiednio pozytywnego i negatywnego wystapienia zmiennej z 1 i 2
  create_clause(TEMP,Result). % tworze z list postaci p,g,h klauzule tzn p v g v h


resolve_for_variables(Element,Clause1,Clause2,Result):-   % resolve potrzebny do predykatu prove rozni sie tym ze nie tworzy isty zmiennych ani nie zamienia wyniku na klauzule
  ord_del_element(Clause1,Element,WynikowaListazPierwszej),negation(Element,NegationofElement),
  ord_del_element(Clause2,NegationofElement,WynikowaListazDrugiej),
  append(WynikowaListazDrugiej,WynikowaListazPierwszej,Temp),
  sort(Temp,Result).

can_we_go_forward(ElementBefore,Clause,ElementAfter):- %predykat sprawdza czy mozna dalej "brnac" w dowod w predykacie find_proof
  negation(ElementBefore,NegElem),
  memberchk(NegElem,Clause),
  change(ElementBefore,ElementAfter).

%predykat zmieniajacy liste zawierajace dowod tzn. doklada nowe elementu do niej tzn. jak cos jest rezolwenta czegos itd.
change_temporary_list_to_collect_solution(ResolutionOfClauses,NewNumber,Element,NumberfromA,NumberfromB,Temporary_List_To_Collect_Solution,NewTemporary_List_To_Collect_Solution):-
    NewTemporary_List_To_Collect_Solution = [[ResolutionOfClauses, NewNumber, (Element,NumberfromA, NumberfromB)] | Temporary_List_To_Collect_Solution],!.

find_proof(Listofvariablesfromclauses,Proof):-   % predykat szukajacy dowodu sprzecznosci zbioru klauzul
  axiom_list(Listofvariablesfromclauses,AxiomList,N),
  find_proof(Listofvariablesfromclauses,Proof,AxiomList,N).

find_proof([[]|_], RESULT, RESULT,_) :- !.% przypadek bazowy  jak znajdzie sie lista pusta [] to koncze i wypisuje dowod
find_proof([H|T], Result, Temporary_List_To_Collect_Solution,Number) :- % w Temporary_List_To_Collect_Solution bedzie przechowywany dowod jak pierwsza lista sie skonczy do zunnifikuje sie z Result - przypadek bazowy
  first_and_last_element([H|T], MainClauseNow, RestOfFirstClauses),  % w kolejnych 3 linijkach pobieram elementy do przeprowwadzenia rezolucji
  first_and_last_element(MainClauseNow, ElementToProof, _),
  first_and_last_element(RestOfFirstClauses, ClauseToResolveWithMainClauseNow, _),
  can_we_go_forward(ElementToProof,ClauseToResolveWithMainClauseNow,Element),  % sprawdzam czy moge przeprowadzic rezolucje i od razu zamieniam ElementToProof na Element bez negacji (o ile wystapiła)
  resolve_for_variables(ElementToProof,MainClauseNow,ClauseToResolveWithMainClauseNow,ResolutionOfClauses), % rezolucje przeprowadzam na ElementToProof potem ewentualnie zamienie kolejnosc zeby było postaci (Element,klazula z pozytywnym wystapieniem elementu,klazula z negatywnym wystapieniem elementu)
  \+ memberchk(ResolutionOfClauses, [H|T]),% jezeli juz rezolwenta juz jest w zbiorze to nie ma co jej dokladac
  new_number(Number,NewNumber), % zwiekszam numer o jeden bo to bedzie kolejny krok w moim dowodzie wiec jego numer bedzie o 1 wiekszy
  turnorder(Element,MainClauseNow,ClauseToResolveWithMainClauseNow,A,B), % zamieniam kolejnosc zrodeł rezolucji o ile to potrzebne zeby było postaci (Element,klazula z pozytywnym wystapieniem elementu,klazula z negatywnym wystapieniem elementu)
  find_numer_of_current_clause(A,Temporary_List_To_Collect_Solution,NumberfromA),% pobieram numer klazuli ktorej urzylem jako pierwszej w rezolucji juz po zamianie kolejnosci
  find_numer_of_current_clause(B,Temporary_List_To_Collect_Solution,NumberfromB),% pobieram numer klazuli ktorej urzylem jako drugiej w rezolucji juz po zamianie kolejnosci
  change_temporary_list_to_collect_solution(ResolutionOfClauses,NewNumber,Element,NumberfromA,NumberfromB,Temporary_List_To_Collect_Solution,NewTemporary_List_To_Collect_Solution),!, % jak wszystko poszło dobrze to dodaje do mojej tymczasowwej listy "trzymajacej" dowod nowa rezolwente
  find_proof([ResolutionOfClauses, H|T], Result, NewTemporary_List_To_Collect_Solution, NewNumber).% idziemy dalej i dajemy ResolutionOfClauses do listy zeby sie nie zapetlic i wiedziec kiedy skocznyc

prove(Clauses,Proof):- % przypadek gdy jedna klazula na wejsciu jest pusta od razu koncze i jako Proof ([],axiom)
  list_clauses(Clauses, List_to_Proof),
  memberchk([],List_to_Proof),
  Proof = [([], axiom)],!. %odcinam poniewaz po wpisaniu ; wypisze false co nie jest prawda

prove(Clauses, Proof) :- % przypadek ogolny nie ma [] na wejsciu wsrod klauzl odcinam pokazuje tylo jeden dowod
      list_clauses(Clauses, List_to_Proof), find_proof(List_to_Proof, RESULT),format_proof(RESULT,Proof).

format_proof(Proof,Result):-  %predykat sluzacy do wypisywania dowodu bo predukat find_proof zostawia go w odwrotnej kolejnosci tzn [] jest pierwsze bo od poczatku dowodzenia sa wrzucane na liste i ostani jest pierwszym
  format_proof(Proof,Result,[]),!. % oraz trzeba usunac numer klazuli a zostawic rezolwente i zjakich ona pochodzi

format_proof([],RESULT,RESULT):-!.
format_proof(PROOF, RESULT, Temporary_List_To_Collect_Solution):-
  first_and_last_element(PROOF, [Clause, _, SourceClausules], ActualEndOfListOfClauses), % "_" to numer ktory był potrzebny predykatowi
  create_clause(Clause,GoodClause),
  format_proof(ActualEndOfListOfClauses, RESULT, [(GoodClause, SourceClausules)|Temporary_List_To_Collect_Solution]).

