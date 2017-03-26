:- op(200, fx, ~).
:- op(500, xfy, v).

variable(X) :- X \= _ v _, X \= ~_.


solve([],[]).

solve([A v B | T], Solution) :- A \= _ v _, solve([A|T], Solution).
solve([A v B | T], Solution) :- A \= _ v _, solve([B|T], Solution).



solve([~A|T],[(A,f)|Y]) :- variable(A),solve(T,Y).

solve([A|T],[(A,t)|Y]) :- variable(A), solve(T,Y).
