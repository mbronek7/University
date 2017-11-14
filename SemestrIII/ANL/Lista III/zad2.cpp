#include <stdio.h>
#include <iostream>
#include <math.h>
using namespace std;
double a,b,c,sgn,x1,x2;
int main() 
{
  a=1.0;
  b=10000000000;
  c=1.0;

   if (b < 0)
        sgn = 1;
    else
        sgn =-1;
        
    x1 = (-b + sgn * sqrt(b*b - 4.0*a*c) ) / (2.0*a) ;
    x2 = c/(x1*a); 
 
    cout << "X1 z Viete'a: " << x1 << endl << "X2 z Viete'a : " << x2 << endl;
    
    x1 = (- b + (sqrt(b * b - 4 * a * c))) / ( 2 * a);
    x2 = (- b - (sqrt(b * b - 4 * a * c))) / ( 2 * a);

    cout << "X1 ze wzorou: " << x1 << endl << "X2 ze wzoru: " << x2 << endl;

    return 0;
}
