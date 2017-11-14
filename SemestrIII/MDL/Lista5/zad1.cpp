#include<bits/stdc++.h>

using namespace std;

int n = 100;
int main()
{
   set<int> test;
   set<int>::iterator it;
   it = test.begin();
   for (int i =1; i <= n ; ++i) {
       if(i%2==0 ||  i%3 == 0 && i%7!=0 && i%5!=0){
        test.insert(it,i);
        it++;
       }
    
   }
       cout<<test.size()<<" ";
    
return 0;
}
