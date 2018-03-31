
expression(A) --> simpleexpression(A),!.
expression(A) --> expression1(B,C), ['*'],!, simpleexpression(C).
expression1(A) -->
simpleexpression(a) -->['a'],!.
simpleexpression(b) -->['b'],!.
simpleexpression(A) -->['('],expression(A),[')'].
