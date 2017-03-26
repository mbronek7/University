% Definiujemy moduł zawierający testy.
% Należy zmienić nazwę modułu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez znaków diakrytycznych
:- module(michal_bronikowski_tests, [tests/5]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).

% Zbiór faktów definiujących testy
% Należy zdefiniować swoje testy

tests(excluded_middle_true, validity, [p v ~p], 500, solution([(p,t)])).
tests(excluded_middle_false, validity, [p v ~p], 500, solution([(p,f)])).
tests(excluded_middle_count, validity, [p v ~p], 500, count(2)).
tests(trivialt,validity,[p],500,solution([(p,t)])).
tests(trivialt_count,validity,[p],500,count(1)).
tests(trivialf,validity,[~p],500,solution([(p,f)])).
tests(trivialf_count,validity,[~p],500,count(1)).
tests(contradictory,validity,[p,~p],500,count(0)).
tests(false_test,validity,[p,t v b v g v j, t v g v s,p v ~p,~p],500,count(0)).
tests(var_duplicate,validity,[p v ~p, j , ~p v w],2000,solution([(p,f),(j,t),(w,t)])).
tests(trap,validity,[p v s, ~s, s v ~p],4000,count(0)).
tests(artful,validity,[p v q v r, ~r v ~q v ~p, ~q v r, ~r],3000,solution( [(p, t), (r, f), (q, f)])).
tests(nasty,validity,[~t v a,~t v ~r v s,~a v r, t , ~s],2000,count(0)).
tests(am_i_naive_implementation,validity,[p v b v c v x, ~b v ~c,~p],2000,solution([ (p, f), (b, f), (c, t), (x, f)])).
tests(abberant,validity,[p v s, ~s v r, ~p v r , ~r v z, ~z],2500,count(0)).
tests(lets_count_something,validity,[p v d v f v e , ~t v f v e v g],3000,count(57)).
tests(three_var,validity,[p , t ,z],500, count(1)).
tests(three_var_seven_solutions,validity,[p v t v z],800,count(7)).
tests(four_var_zero_solutions,validity,[p v t v z v q , a v b v c v q,~p,~t,~z,~q,~a,~b,~c,~q],1000, count(0)).
tests(only_one_clause_and_empty, validity, [[]], 800, count(0)).
tests(one_clause_is_empty,validity,[p v t , ~z, [], r],800,count(0)).
tests(seven_variables_3_solutions,validity,[p v s , t , f , e , q , f v ~s],800,count(3)).
% performance tests
tests(little_complicatation,performance,[p v q , r v s , t v p v q v s,t v ~q v x v g v t, c v b v t v r v w , ~r v ~t v ~s v ~y, ~w v g],500,solution([ (w, f), (g, f), (r, f), (t, t), (s, t), (y, t), (c, f), (b, t), (q, f), (x, t), (p, t)] )).
tests(puzzle,performance,[p v c v b v g, t v r v e v w , ~q v ~w v ~t v r v i ,p v b v f v k v l ],500,solution( [ (p, t), (b, t), (f, t), (k, t), (l, t), (q, f), (w, f), (t, f), (r, f), (i, t), (e, t), (c, f), (g, t)])).
tests(big_trap,performance,[p ,d , f , g , h , m , n , u , i , o , p , q , w , e , r , a , z , x , c , d , f , y , t ,~p , ~d , ~f , ~g , ~h , ~m , ~n , ~u , ~i , ~o , ~p ,~q , ~w , ~e , ~r , ~a , ~z , ~x , ~c , ~d , ~f ,~y , ~t ],1000,count(0)).
tests(is_it_stupid_implementation,performance,[p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p v p],3000,solution([(p,t)])).
tests(counting,performance,[p v q , r v s , t v p v q v s,t v ~q v x v g v t, c v b v t v r v w , ~r v ~t v ~s v ~y, ~w v g],500,count(724)).
tests(just_another_performance_test,performance,[p v b v c v f v g v h v j v e v w v q v r v t ],500,solution([ (p, t), (b, f), (c, f), (f, t), (g, f), (h, t), (j, t), (e, f), (w, t), (q, t), (r, f), (t, t)])).
tests(duplicate_one_clause,performance,[p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s, p v ~p v t v ~s],500,solution([(p,f),(t,f),(s,f)])).
tests(only_empty_caluses, performance, [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []], 500, count(0)).
tests(negation,performance,[a1 v a2 v a3 v a4 v a5 v a6 v a7 v a8 v a9 v a10 v a11 v a12 v a13 v a14 v a15 v a16 v a17 v a18 v a19 v a20 v a21 v a22 v a23 v a24, ~a1 v ~a2 v ~a3 v ~a4 v ~a5 v ~a6 v ~a7 v ~a8 v ~a9 v ~a10 v ~a11 v ~a12 v ~a13 v ~a14 v ~a15 v ~a16 v ~a17 v ~a18 v ~a19 v ~a20 v ~a21 v ~a22 v ~a23 v ~a24],10000,solution( [ (a1, t), (a2, t), (a3, t), (a4, t), (a5, t), (a6, t), (a7, t), (a8, t), (a9, t), (a10, t), (a11, t), (a12, t), (a13, t), (a14, t), (a15, t), (a16, t), (a17, t), (a18, t), (a19, t), (a20, t), (a21, t), (a22, f), (a23, t), (a24, t)])).
