empty(leaf).% drzewo jest puste kiedy nie ma zadnych galezi ani wartosci czyli jest lisciem

insert(leaf, Element, node(leaf,Element,leaf) ). % jak drzewo jest puste to wartosc w korzen a liscie na lewo i prawo
insert(node(Left, Root, Right), Element, node(Left,Root,Result) ) :- %wkladanie do drzewa z wezlami z lewej i prawej
	Element > Root,!, % element jest wiekszy od korzenia odcinam
	insert(Right,Element, Result).
insert(node(Left, Root, Right), Element, node(Result,Root,Right) ) :-
	insert(Left,Element, Result).

find(Element, node(_,Element,_)) :- !. % przypadek bazowy
find(Element, node(_,Root,Right)) :- % przypadek dla elementu > od korzenia
	Element > Root, !, % odcinam
	find(Element,Right). % szukam po prawej stronie
find(Element, node(Left,_,_)) :- % jak nie był wiekszy wyzej to jest po lewej stronie
	find(Element,Left).

findMax(node(_,Root,leaf),Root ) :- !. % przypadek bazowy  jak zejde z prawej na maxa w dol
findMax(node(_,_,Right), Element ) :- % nie interesuje nas co było po lewej bo schodzimy na maxa w prawo
	findMax(Right,Element). % schodze ciagle w prawo

delete(_,leaf,leaf):-!.  % przypadek bazowy
delete(Element, node(leaf, Element, leaf), leaf):-!. % jak mam wezel z tym elementem to go wywalam i zostaje mi lisc sam
delete(Element, node(Left,Element,leaf), Left):-!. % przypadek jak na lewo jest cos to to zostaje
delete(Element , node(leaf,Element,Right), Right):-!.% analogicznie jak mam w korzeniu element na lewo lisc to zostaje to co po prawej
delete(Element, node(Left, Element, Right), node( Left_Removed , L_Max, Right )) :- % usuwanie elementu zkorzenia jak dwa ma po L i P wywalam z lewej
%element maksymalny i on staje sie korzeniem a prawe zostaje bez zmian
	findMax(Left,L_Max),
	delete(L_Max,Left, Left_Removed), ! . % odcinam koniec

delete(Element, node(Left, Root, Right), node(Left,Root,Right_Removed) ) :- % wlasciwy predykat
	Element > Root, !, % element > od korzenia odcinam
	delete(Element,Right,Right_Removed).% usuwam go z prawej strony
delete(Element, node( Left, Root, Right), node(Left_Removed, Root, Right) ) :- % drugi przypadek jest po lewej stronie
	delete(Element,Left, Left_Removed).% usuwam go z lewej strony

delMax( Tree, Max, Out_Tree ) :- % predykat do usuwania z drzewa maxima
 	findMax(Tree,Max),% szukam tego maxima
 	delete(Max,Tree,Out_Tree). % i je usuwam
