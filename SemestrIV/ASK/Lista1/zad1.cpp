#include <iostream>

int main(){
    int x,i,k;
    std::cin>>x>>i>>k;
    x = ( x & ~(1 << k)) | (((x & ( 1 << i)) >> i ) << k);
    std::cout<<x;
    return 0;
}
