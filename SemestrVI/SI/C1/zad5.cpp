#include <iostream>
#include <cmath>
using namespace std;

long long sil(long long a){
    long long b = 1;
    for(long long i = 1; i <= a; i++){
        b = b * i;
    }
    return b;
}

long long nue(long long a, long long b){
    if(a-b > b)
        b = a-b;
    long long s = 1;
    for(long long i = b+1; i <= a; i++){
        s = s * i;
    }
    return s/sil(a-b);
}

int main()
{
    long long wys[2][11];
    //figurant
    wys[0][0] = nue(16,5);//wszystkie wystapienia
    wys[0][10] = 0; // poker krolewski
    wys[0][9] = 0; // poker
    wys[0][8] = nue(4,1)*nue(4,4)*nue(12,1); // Kareta
    wys[0][7] = nue(4,1)*nue(4,3)*nue(3,1)*nue(4,2); // Ful
    wys[0][6] = 0; // Kolor
    wys[0][5] = 0; // Strit
    wys[0][4] = nue(4,1)*nue(4,3)*nue(3,2)*pow(nue(4,1),2); // Trojka
    wys[0][3] = nue(4,2)*pow(nue(4,2),2)*nue(2,1)*nue(4,1); // dwie pary
    wys[0][2] = nue(4,1)*nue(4,2)*nue(3,3)*pow(nue(4,1),3); // para
    long long s = 0;
    for(int i = 10; i != 1; i--)
        s = s + wys[0][i];
    wys[0][1] = wys[0][0] - s; // Wysoka karta
    //blotkarz
    wys[1][0] = nue(36,5); // wszystkie wystapienia
    wys[1][10] = 0; // poker krolewski
    wys[1][9] = nue(5,1)*nue(4,1); // poker
    wys[1][8] = nue(9,1)*nue(4,4)*nue(32,1); // kareta
    wys[1][7] = nue(9,1)*nue(4,3)*nue(8,1)*nue(4,2); // ful
    wys[1][6] = nue(9,5)*nue(4,1) - wys[1][9]; // kolor
    wys[1][5] = nue(5,1)*pow(nue(4,1),5) - wys[1][9]; // strit
    wys[1][4] = nue(9,1)*nue(4,3)*nue(8,2)*pow(nue(4,1),2); // trojka
    wys[1][3] = nue(9,2)*pow(nue(4,2),2)*nue(7,1)*nue(4,1); // dwie pary
    wys[1][2] = nue(9,1)*nue(4,2)*nue(8,3)*pow(nue(4,1),3); // para
    s = 0;
    for(int i = 10; i != 1; i--)
        s = s + wys[1][i];
    wys[1][1] = wys[1][0] - s; // wysoka karta

    double P[2][11]; //prawdopodobienstwo
    for(int i = 0; i != 2; i++){
        for(int j = 0; j != 11; j++){
            P[i][j] = (double)(wys[i][j]) /(double)(wys[i][0]);
        }
    }
    double bwin = 0;
    for(int i = 1; i != 11; i++){
        double fwin = 0;
        for(int j = i; j != 11; j++)
            fwin = fwin + P[0][j];
        bwin = bwin + P[1][i]*(1-fwin);
    }
    cout << bwin * 100;
}
