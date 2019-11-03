Flags = -std=c99 -Wall -Wextra

traceroute: main.o traceroute.o
	gcc -o traceroute main.o traceroute.o $(Flags)

traceroute.o : traceroute.c traceroute.h
	gcc -o traceroute.o -c traceroute.c $(Flags)

main.o : main.c traceroute.h
	gcc -o main.o -c main.c $(Flags)

clean:
	rm *.o traceroute