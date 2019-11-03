## Zadanie programistyczne nr 1 z Sieci komputerowych

Program traceroute, wyświetlający adresy IP routerów na ścieżce do docelowego ad-resu IP. Program działa w trybie tekstowym i jego jedynym argumentem powinien być adres IP komputera docelowego. Program wysyła pakiety ICMPecho requesto o coraz większych wartościach TTL(podobnie jak robi to wywołanie traceroute -I.

Przykładowy wynik działania programu:

```
 > sudo ./traceroute 8.8.8.8

 1   192.168.1.1 1.481000 ms
 2   156.17.162.254 9.467000 ms
 3   156.17.254.64 2.781667 ms
 4   156.17.254.111 1.156667 ms
 5   156.17.250.222 1.302333 ms
 6   212.191.237.121 9.833000 ms
 7   80.249.208.247 27.196333 ms
 8   108.170.241.193 26.459667 ms
 9   108.170.236.147 30.237000 ms
10   8.8.8.8 26.946333 ms

```

⋅⋅* Program należy uruchamiać z uprawnieniami administratora
⋅⋅* W przypadku braku odpowiedzi od jakiegokolwiek routera wyświetlony zostanie symbol '*'
--* W przypadku nieotrzymania trzech odpowiedzi w nieustalonym czasie, zamist średniego czasu zostanie wyświetlony ciąg symbolii '???'
--* Podane dane wejściowe są sprawdzane pod względem poprawności

Do kompilacji można użyc dostępnego Makefile'a, dostępne polecenia:
--* make - skompiluje program pod nazwą traceroute
--* make clean - wyczyści folder, z tymczasowych obiektów (plików *.o)
--* make distclean - usunie skompilowane programy i zostawi tylko plikii źródłowe

W przypadku gdy program wypisze: "*???", zaleca się ponowne uruchomienie z tymi samymi parametrami.