//MICHAL BRONIKOWSKI, 292227 
#include <iostream>
#include <algorithm>


int main()
{

    std::ios::sync_with_stdio(false);
    std::cin.tie(NULL);

    int a,b;
    std::cin>>a>>b;
    if(a>b)  std::swap(a,b);
    std::cout<<a<<"\n";
    while(a<b)
    {
       a++;
       std::cout<<a<<"\n";
    }
    return 0;
}



