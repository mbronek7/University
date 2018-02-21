% Definiujemy moduł zawierający testy.
% Należy zmienić nazwę modułu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(michal_bronikowski_tests, [tests/3]).

% Zbiór faktów definiujących testy
% Należy zdefiniować swoje testy
tests(empty_program, input(""), program([])).
tests(invalid, input("def main()"), no).
tests(adder, file('adder.hdml'), yes).
/*
tests(srcpos, input("def main(_) = 1"),
  program([def(main, wildcard(file(test, 1, 10, 9, 1)), num(no, 1))])).
tests(lets_try_to_comment_all, input("(*def wrong_program (*X = wrong*) wro(*ng (*^ wrong*) *)*)"), yes).
tests(invalid_comment,file('adderwithcomments.hdml'),no).
tests(correct_definition,file('program1.hdml'),yes).
tests(incorrect_definition,file('program2.hdml'),no).
tests(correct_program,file('program3.hdml'),yes).
tests(tests_with_program,file('program4.hdml'),program([def(add, pair(no, var(no, 'a'),pair(no,wildcard(no),var(no,'B'))), op(no, '+', var(no, 'a'), var(no, 'B')))])).
tests(too_many_keywords,input("def main(_,_,_,_) = if then else = else if then []"),no).
tests(wrong_argument,input("def main(A,else,in,let) = else + let"),no).
tests(call_of_wrong_function,file('program5.hdml'),no).
tests(crafty_name,input("def ifthenelseprogram (A, B) = A * B + 1"),yes).
tests(define_without_def, input("main(A, B, C) = let C1, S1 = ripple_carry_adder(A, B, C) in let C2, S2 = log_depth_adder(A, B, C) in ~((C1 ^ C2) | or_of(S1 ^ S2))"),no).
tests(where_is_then, input("def main(F,L) = if L = 0 else B * L + 1"),no).
tests(wildcar_as_everything, input("def _(_) = _"), no).
tests(add_feature, input("def main(A,B) =  if A+B = 0 then return A*B"),no).
tests(another_if_then_else_test, input("def main(A,B) = if A = 159 then B"),no).
tests(new_operator,input("def main(A, B) = A +*/ /*B"),no).
tests(where_is_in, input("def main(A,B) = let A = 657"),no).
tests(another_wrong_let,input("def main(A,B) = let A + 1 in B")).
tests(is_it_unary, input("def main(A,B) = B - A ,A ~ B, A # B"),no).
tests(lot_of_whitespaces,input("             def main(               _)             =               1   "),yes).
tests(def_test,input(" def main(_) = def"),no).
tests(invalid_comment, input("def go(**)to(a) = 58"), no).
tests(long_yes_test,file('program6.hdml'),yes).
tests(long_no_test,file('program7.hdml'),no).
tests(wildcard_name,input("def _main(A,B) = A + B"),yes).
tests(wildcard_name_tree,input("def _main(A,B) = A + B"),program([def('_main', pair(file(test, 1, 11, 10, 3), var(file(test, 1, 11, 10, 1), 'A'), var(file(test, 1, 13, 12, 1), 'B')), op(file(test, 1, 22, 21, 1), +, var(file(test, 1, 18, 17, 1), 'A'), var(file(test, 1, 22, 21, 1), 'B')))])).
tests(let_before_def,input("let def main(A,B) = A + B"),no).
tests(sth_before_def,input("blabalbla def main(A,B) = A + B"),no).
tests(another_wrong_name,input(" def (A,B) = 5 + B"),no).
tests(let_add_C_lang,input(" def int (int A, int B) = A % B, return 0"),no).
tests(test_like_other,input("def main(A, B) = A + B,A * B, A ^ B, A # B"), no).
tests(test_like_other2,input("def main(A, B) = A + B,A * B, A ^ B"), yes).
tests(undef,input("undef main(_) = 1"),no).
tests(sthcopiedfromskos, input("def main(_) = A"),program([def(main, wildcard(file(test, 1, 10, 9, 1)), var(no, 'A'))])).
tests(upper_Name,input("def Main(A,B) = A + B"),yes).
tests(def_name,input("d_e_f Main(A,B) = A + B"),no).
tests(number_in_name,input("def main(A,90B) = A"),no).
tests(name_with_apostrophe,input("def 'main(A,B) = A * B"),no).
tests(comments,input(" (* lalaallalalalala *) def main(A,B) = 2 * A + B"),yes).
tests(another_comments_test,input(" (* lalaallalalalala *) def main(A,B) = 2 * A (*dfsadfdsafsd(*(*(*(*(*(*(*(*(*(*(*(*(*(*(*)*)+ B(*(*(*))*)"),no).
*/

tests(wildcard, input("def main(_) = 1"),
      program([def(main, wildcard(no), num(no, 1))])).

tests(and, input("def main(A) = A & B"),
      program([
        def(main, var(no, 'A'), op(no, &, var(no, 'A'), var(no, 'B')) )
      ])).

% Variables

tests(variable_starting_underscore, input("def main(_A) = 1"),
      program([def(main, var(no, '_A'), num(no, 1))])).

tests(variable_inside_underscore, input("def main(A_A) = 1"),
      program([def(main, var(no, 'A_A'), num(no, 1))])).

tests(variable, input("def main(A) = 1"),
      program([def(main, var(no, 'A'), num(no, 1))])).

tests(variable_with_keyword, input("def main(defA) = 1"),
      program([def(main, var(no, 'defA'), num(no, 1) )])).

tests(variable_with_keywords, input("def main(def_deflet_in_else) = 1"),
      program([def(main, var(no, 'def_deflet_in_else'), num(no, 1) )])).

% Whitspaces

% Should result to same program, no matter of the whitspaces
tests(white_spaces1, input("def main(A     ) = 1 "),
      program([def(main, var(no, 'A'), num(no, 1) )])).

tests(white_spaces2, input("def    main(A     ) =    1"),
      program([def(main, var(no, 'A'), num(no, 1) )])).

tests(white_spaces3_newline, input("def main(A) \n = \n\n 1"),
      program([def(main, var(no, 'A'), num(no, 1) )])).

% Comments

tests(comment, input("def main(A) = (* Comment *) 1 "),
      program([def(main, var(no, 'A'), num(no, 1) )])).

tests(comment_with_code, input("def main(A) = (* A ^ B *) 1 "),
      program([def(main, var(no, 'A'), num(no, 1) )])).

tests(nesting_comments,
      input("def main(A) = (* Comment (* Nested one *) *) 1 "),
      program([def(main, var(no, 'A'), num(no, 1) )])).

tests(comment_all, input("(* def main(A) = Comment  1 *)"), yes).


% Should not confuse <= and < :
tests(lte, input("def main(A) = A <= B"),
      program([
        def(main, var(no, 'A'), op(no, <=, var(no, 'A'), var(no, 'B')) )
      ])).

tests(lt, input("def main(A) = A < B"),
      program([
        def(main, var(no, 'A'), op(no, <, var(no, 'A'), var(no, 'B')) )
      ])).

% Invalid tokens

tests(invalid_token1, input("def main(A) = {{{{"), no).
tests(invalid_token2, input("def main({}{}{}) = 1"), no).


% Test parser
% ---------------------

tests(invalid, input("def main()"), no).

tests(basic_parser_bug, input("def main(_) = def"), no).
tests(invent_keyword, input("async def main(_) = A"), no).
tests(no_def_name, input("def (_) = A"), no).

tests(many_definitions,
      input("def first(A) = 1 \n def second(B) = 2 \n def third(_) = A"),
      program([
        def(first, var(no, 'A'), num(no, 1)),
        def(second, var(no, 'B'), num(no, 2)),
        def(third, wildcard(no), var(no, 'A'))
      ])).


tests(if_else, input("def main(A) = if A then B else C"), yes).
tests(if_else_invalid_tokens, input("def main(A) = if ~ then B else C"), no).

tests(let_in, input("def main(A) = let _ = A in B"), yes).
tests(let_in_invalid, input("def main(A) = let # = A in B"), no).

tests(unary_op, input("def main(A) = ~A"), yes).
tests(spam_unary_op, input("def main(A) = ~~~~~~A"), yes).
tests(unary_and_binary_op_invalid, input("def main(A) = ~A & B"), yes).

tests(bitsel, input("def main(A) = A1 [ A2 ]"), yes).
tests(bitsel2, input("def main(A) = A1 [ A2 .. A3]"), yes).
tests(bitsel2_invalid, input("def main(A) = A1 [ A2 .. .. .. A3]"), no).

tests(operators_associativity, input("def main(A) = A - B * C"),
      program(
        [def(main, var(no, 'A'), op(no, -, var(no, 'A'), op(no, *, var(no, 'B'), var(no, 'C'))))]
      )).
