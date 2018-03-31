#include<bits/stdc++.h>

using namespace std;

int n = 800;
int k=0;
int main()
{
   for (int i =1; i <= n ; ++i) {
       if( (i%6==0 ||  i%9==0)  && i%7!=0 ){
       k++;
       }
    
   }
       cout<<k;
    
return 0;
}
