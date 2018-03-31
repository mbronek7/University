#include <iostream>
#include <math.h>
#define TEMP(r,q) (pow(cbrt(r + sqrt((pow(q,3) + pow(r,2)))),2))
long double  r = 1 , q = 1000000000000;

int main()
{
	std::cout<<"Ze wzoru:\n";
	double x1 = cbrt(r + sqrt(pow(q,3)+pow(r,2))) + cbrt(r - sqrt(pow(q,3)+pow(r,2)));
	std::cout<<x1<<"\nPoprawione:\n";
        double temp = TEMP(r,q); 
        double x2 = (2 * r * temp) / (pow(temp,2) + q * temp + pow(q,2));
	std::cout<<x2<<std::endl;
	return 0;
}


