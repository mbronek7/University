//MICHAL BRONIKOWSKI
//292227
//KPI

#include <iostream>
#include <math.h>


int main()
{

    std::ios::sync_with_stdio(false);
    std::cin.tie(NULL);

    int a,b,step,k=2018;
    std::cin>>a>>b;
    step = ( a % 2018 ) ? a/2018 + 1 : a/2018;
    while(k * step <= b )
    {
        std::cout<<k*step<<" ";
        step++;
    }
    return 0;
}



