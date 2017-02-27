male(adam).
male(john).
male(joshua).
male(david).
male(mark).
female(eve).
female(helen).
female(ivonne).
female(anna).
parent(adam, helen).
parent(adam, ivonne).
parent(adam, anna).
parent(eve, helen).
parent(eve, ivonne).
parent(eve, anna).
parent(helen, joshua).
parent(john, joshua).
parent(ivonne, david).

sibling(X,Y) :- parent(Z,X),parent(Z,Y).
sister(X,Y) :- female(X),sibling(X,Y).
grandson(X,Y) :- male(X),parent(Z,X),parent(Y,Z).
cousin(X,Y) :- male(X),parent(Z,X),parent(V,Y),sibling(Z,V).
descedent(X,Y) :- parent(Y,X).
descendant(X,Y):- 
	parent(Y,Z), descendant(X,Z).
is_mother(X) :- female(X),parent(X,Z).
is_father(X) :- male(X),parent(X,Z).
