sublist(_,[]). % lista pusta jest podlistą każdej listy przypadek bazowy
sublist([H|T],[H|S]):-  %jezeli moge podstawić głowę to zabieram ją
  sublist(T,S).
sublist([_|T],S):- %jezeligłowa jest inna w liscie l1 to ide dalej i biorę zniej ogon i go porównuje z S
  sublist(T,S).
