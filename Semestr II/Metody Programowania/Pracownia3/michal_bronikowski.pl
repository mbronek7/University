% Definiujemy moduł zawierający rozwiązanie.
% Należy zmienić nazwę modułu na {imie}_{nazwisko} gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(michal_bronikowski, [parse/3]).


/*

ROZWIAZANIE WZOROWANE NA PRZYKŁADOWYM PARSERZE DCG ZAMIESZCZONYM NA SKOSIE PRZEZ WYKLADOWCE
SKORZYSTALEM ROWNIEZ ZE SCHEMATU USUWANIA REKURSJI LEWOSTRONNEJ PODANEGO PRZEZ PANA DR. MARKA MATERZOKA NA CWICZENIACH Z MP W DNIU 25.04.2017

JEZELI NA PRZYKLAD : (PRZYKLAD Z CWICZEN LEKKO ZMODYFIKOWANY PRZYPOMINA SYSTUACJE ZE WZORCEM Z TEGO ZADANIA)
S -> p
S -> S,S

S -> Simple_S
Simple_S ->p
S -> Simple_S,S

*/

/* LEXER */
lexer(Tokens) -->
    white_space,
   (  ( "&",       !, { Token = tokAmpersand }
      ;  "*",       !, { Token = tokTimes }
      ;  "/",       !, { Token = tokSlash }
      ;  "^",       !, { Token = tokCaret }
      ;  "|",       !, { Token = tokPipe }
      ;  "+",       !, { Token = tokPlus }
      ;  "-",       !, { Token = tokMinus }
      ;  "%",       !, { Token = tokPercent }
      ;  "@",       !, { Token = tokAmpersat }
      ;  "#",       !, { Token = tokHash }
      ;  "~",       !, { Token = tokTilde }
      ;  "(",       !, { Token = tokLParen }
      ;  ")",       !, { Token = tokRParen }
      ;  "[",       !, { Token = tokOBracket }
      ;  "]",       !, { Token = tokCBracket}
      ;  "..",      !, { Token = tokDdot }
      ;  ",",       !, { Token = tokComma }
      ;  "=",       !, { Token = tokEq }
      ;  "<>",      !, { Token = tokNeq }
      ;  "<=",      !, { Token = tokLeq }
      ;  ">=",      !, { Token = tokMeq }
      ;  "<",       !, { Token = tokLess}
      ;  ">",       !, { Token = tokMore}


      ;  digit(D),  !,
            number(D, N),
            { Token = tokNumber(N) }
      ;  letter(L), !, identifier(L, Id),
        {  member((Id, Token), [ (def, tokDef), ('_', tok_), (if, tokIf), (in, tokIn), (else, tokElse), (then, tokThen), (let, tokLet)]),
               !;  Token = tokId(Id) }
      ;  [_],
            { Token = tokUnknown }
      ),
      !,
    { Tokens = [Token | TokList] },
    lexer(TokList)
    ;  [],
    { Tokens = [] }
    ).

white_space --> [Char], { code_type(Char, space) }, !, white_space.
white_space --> comment, !, white_space.
white_space --> [].

comment -->"(*",comment(1).

comment(Poziom) -->
  "*)",
  {
      Poziom > 0,
      PoprzedniPoziom is Poziom - 1
  },
  !,
  comment(PoprzedniPoziom).

comment(Poziom) -->
  "(*",
  { PoziomNastepny is Poziom + 1 },
  !,
  comment(PoziomNastepny).

comment(0) --> [].

comment(Poziom) -->
  [_],
  comment(Poziom).

comment(_) :- fail.

digit(D) -->
   [D],
      { code_type(D, digit) }.

digits([D|T]) -->
   digit(D),
   !,
   digits(T).
digits([]) -->
   [].

number(D, N) -->
   digits(Ds),
      { number_chars(N, [D|Ds]) }.

letter(L) -->
   [L], { code_type(L, csymf) }.

alphanum([A|T]) -->
   [A], { A == 39 ; code_type(A, csym)  }, !, alphanum(T).
alphanum([]) -->
   [].

identifier(L, Id) -->
   alphanum(As),
      { atom_codes(Id, [L|As]) }.



/* PARSER */
program(Ast) -->
 definicje(Ast).

definicje(DEF) -->
  definicja(D),
  definicje(D2),
  {DEF = [D|D2]}.

definicje([]) --> [].

definicja(D) -->
  [tokDef],
  [tokId(Def_Id)],
  [tokLParen],
  wzorzec(WZ),
  [tokRParen],
  [tokEq],
  wyrazenie(W),
  {D = def(Def_Id,WZ,W)}.

wzorzec(WZ) -->
  wzorzec_pomocniczy(WZ).

wzorzec(W) -->
  wzorzec_pomocniczy(W1),
  [tokComma],
  wzorzec(W2),
  {W = pair(no,W1,W2)}.

wzorzec_pomocniczy(WZ) -->
   [tok_],!,
   {WZ = wildcard(no)}.

wzorzec_pomocniczy(WZ) -->
   zmienna(WZ),!.

wzorzec_pomocniczy(WZ) -->
  [tokLParen],!,
   wzorzec(WZ),
  [tokRParen].

wyrazenie(W) -->
  [tokIf],!,
   wyrazenie(E1),
   [tokThen],
   wyrazenie(E2),
   [tokElse],
   wyrazenie(E3),
   {W = if(no,E1,E2,E3)}.

wyrazenie(W) -->
  [tokLet],!,
  wzorzec(P),
  [tokEq],
  wyrazenie(E1),
  [tokIn],
  wyrazenie(E2),
  {W = let(no,P,E1,E2)}.

wyrazenie(W) -->
  wyrazenieop(W).

wyrazenieop(W) -->
	wyrazenie_binarne(E1),
  [tokComma],!,
  wyrazenieop(E2),
  {W = pair(no, E1, E2)}.

wyrazenieop(E1) -->
  wyrazenie_binarne(E1).

/* DEFINICJE OPERATOROW Z UWZGLEDNIENIEM PODZIALU NA LACZENIE I PRIORYTET */

operatorbraklacznosci('=') --> [tokEq].
operatorbraklacznosci('<>') --> [tokNeq].
operatorbraklacznosci('<=') --> [tokLeq].
operatorbraklacznosci('>=') --> [tokMeq].
operatorbraklacznosci('<') --> [tokLess].
operatorbraklacznosci('>') --> [tokMore].

operatorarytmetycznyslabszy('|') --> [tokPipe].
operatorarytmetycznyslabszy('^') --> [tokCaret].
operatorarytmetycznyslabszy('+') --> [tokPlus].
operatorarytmetycznyslabszy('-') --> [tokMinus].

operatorarytmetycznymocniejszy('&') --> [tokAmpersand].
operatorarytmetycznymocniejszy('*') --> [tokTimes].
operatorarytmetycznymocniejszy('/') --> [tokSlash].
operatorarytmetycznymocniejszy('%') --> [tokPercent].

operatorunarny('-') --> [tokMinus].
operatorunarny('#') --> [tokHash].
operatorunarny('~') --> [tokTilde].

operator_ampersat('@') --> [tokAmpersat].

wyrazenie_binarne(W) -->
	wyrazenie_z_ampersat(E1),
  operatorbraklacznosci(Op),
  wyrazenie_z_ampersat(E2),
  {W = op(no, Op, E1, E2)}.

wyrazenie_binarne(E1) -->
  wyrazenie_z_ampersat(E1).

wyrazenie_z_ampersat(W) -->
	wyrazenie_arytmetyczne_z_slabszym_operatorem(E1),
   operator_ampersat(Op),
   wyrazenie_z_ampersat(E2),
   {W = op(no, Op, E1, E2)}.

wyrazenie_z_ampersat(E1) -->
  wyrazenie_arytmetyczne_z_slabszym_operatorem(E1).

wyrazenie_arytmetyczne_z_slabszym_operatorem(A) -->
	wyrazenie_arytmetyczne_z_mocniejszym_operatorem(A1),
	wyrazenie_arytmetyczne_z_slabszym_operatorem(A1,A).

wyrazenie_arytmetyczne_z_slabszym_operatorem(ACC, W) -->
	operatorarytmetycznyslabszy(Op), !,
	wyrazenie_arytmetyczne_z_mocniejszym_operatorem(A1),
	{ACC2 = op(no, Op, ACC, A1)},
	wyrazenie_arytmetyczne_z_slabszym_operatorem(ACC2, W).

wyrazenie_arytmetyczne_z_slabszym_operatorem(W,W) --> [].

wyrazenie_arytmetyczne_z_mocniejszym_operatorem(W) -->
	wyrazenie_unarne(W1),
	wyrazenie_arytmetyczne_z_mocniejszym_operatorem(W1,W).

wyrazenie_arytmetyczne_z_mocniejszym_operatorem(AC, A) -->
	operatorarytmetycznymocniejszy(Op), !,
	wyrazenie_unarne(A1),
	{AC1 = op(no, Op, AC, A1)},
	wyrazenie_arytmetyczne_z_mocniejszym_operatorem(AC1, A).

wyrazenie_arytmetyczne_z_mocniejszym_operatorem(W,W) --> [].

wyrazenie_unarne(U) -->
	operatorunarny(Op),
  wyrazenie_unarne(U1),
  {U = op(no, Op, U1)}.

wyrazenie_unarne(U) -->
  wyrazenie_proste(U).

wyrazenie_proste(W) -->
[tokLParen],
wyrazenie(W),
[tokRParen].

wyrazenie_proste(W) -->
	wyrazenieatomowe(A),
	wyrazenie_proste(A,W).

wyrazenie_proste(ACC,W) -->
	wybor_bitu(B),
	{ACC2 = bitsel(no, ACC, B)},
	wyrazenie_proste(ACC2, W).

wyrazenie_proste(ACC, E) -->
  wybor_bitow(B1,B2),
  {ACC2 = bitsel(no, ACC, B1, B2)},
  wyrazenie_proste(ACC2, E).

wyrazenie_proste(W,W) --> [].

wyrazenieatomowe(A) --> zmienna(A).
wyrazenieatomowe(A) --> wywolaniefunkcji(A).
wyrazenieatomowe(A) --> literalcalkowitoliczbowy(A).
wyrazenieatomowe(A) --> pustywektor(A).
wyrazenieatomowe(bit(no, A)) --> [tokOBracket], wyrazenie(A), [tokCBracket].

zmienna(A) -->
  [tokId(N)],!,
  { A = var(no,N) }.

literalcalkowitoliczbowy(A) -->
  [tokNumber(N)],!,
  {A = num(no,N)}.

wywolaniefunkcji(C) -->
  [tokId(N)],
  [tokLParen],!,
  wyrazenie(Arg),
  [tokRParen],
  {C = call(no,N,Arg)}.

pustywektor(A) -->
  [tokOBracket],
  [tokCBracket],!,
  {A = empty(no)}.

pojedynczybit(A) -->
  [tokOBracket],!,
  wyrazenie(A),
  [tokCBracket],
  {A = bit(no,A)}.

wybor_bitu(E2) -->
  [tokOBracket],!,
  wyrazenie(E2),
  [tokCBracket].

wybor_bitow(E2,E3) -->
  [tokOBracket],
  wyrazenie(E2),
  [tokDdot],
  wyrazenie(E3),
  [tokCBracket].


/* KONIEC PARSERA PONIZEJ DEFINICJA PREDYKATU parse/3 */

parse(_,X, Absynt) :-
   phrase(lexer(TokList), X),
   phrase(program(Absynt), TokList).
