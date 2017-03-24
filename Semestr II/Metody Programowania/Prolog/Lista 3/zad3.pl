
factorial(0, 1).
factorial(N, M) :-
   N > 0,
   X is N-1,
   factorial(X,Y),
   M is N*Y.

%------------------------------------------------
concat_number(X,Y):-
  concat_number(X,0,Y).

concat_number([],Res,Res).
concat_number([H|T],Element,Res):-
  NextDigit is (Element * 10) + H,
  concat_number(T,NextDigit,Res).
%------------------------------------------------
decimal(X,Y):-
  decimal(X,[],Y).

decimal(0,Res,Res):-
  !.

decimal(X,Digits,Res):-
  CurrentDigit is X mod 10,
  Element is X //10,
  decimal(Element,[CurrentDigit|Digits],Res).
