
def exam(listy, kol1, kol2):
    na30 = 0.33;
    na35 = 0.48;
    na40 = 0.58;
    na45 = 0.68;
    na50 = 0.78;

    zlist = listy/140;
    zkol1 = kol1/70;
    zkol2 = kol2/70;

    ocena = min(zkol1, zkol2, zlist);

    if (ocena == None): return None;
    if (ocena >= na50): return 5;
    if (ocena >= na45): return 4.5;
    if (ocena >= na40): return 4;
    if (ocena >= na35): return 3.5;

    return None


def calc(listy, kol1, kol2):
    zaliczenie = 0.3;
    na30 = 0.35;
    na35 = 0.5;
    na40 = 0.6;
    na45 = 0.7;
    na50 = 0.8;

    zlist = listy/140;
    zkol1 = kol1/70;
    zkol2 = kol2/70;
    zkol = (zkol1 + zkol2)/2;

    ocena = (zkol + zlist)/2;

    print("\nSrednia: ", ocena)

    wstepny = min(max(zkol1, zkol2), zlist);

    if (wstepny < zaliczenie): return None

    if (ocena >= na50): return 5;
    if (ocena >= na45): return 4.5;
    if (ocena >= na40): return 4;
    if (ocena >= na35): return 3.5;
    if (ocena >= na30): return 3;
    if (ocena >= 0): return None;

    return None;


def output():
    listy = int(input("Listy: "))
    zkol1 = int(input("Kolokwium 1: "))
    zkol2 = int(input("Kolokwium 2: "))
    wynik = calc(listy, zkol1, zkol2)
    print("\nOcena: ", wynik or "Ujebiesz\n")
    if wynik:
        print("\nZ egzaminu: ", exam(listy, zkol1, zkol2) or "Musisz podejsc pod egzamin")


if __name__ == '__main__':
    output()

