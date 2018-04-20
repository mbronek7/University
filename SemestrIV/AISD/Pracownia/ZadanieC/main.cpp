// Michał Bronikowski, 292227
#include <limits.h> 
#include <stdio.h>
#include <deque>
#define MAX 1000007
int n,l,b,GUESS; 
int DISTANCE_FROM_BEGIN[MAX];
long long int COST[MAX]; 
long long int RESULT = LLONG_MAX;
long long int OPTIMAL_COST_TO[MAX];

int main() {
  scanf("%d%d%d",&n,&l,&b);
  for(int i=1;i<=n;++i)
    scanf("%d%d",&DISTANCE_FROM_BEGIN[i],&COST[i]);
  if(b >= l ) {printf("0"); return 0; }
  DISTANCE_FROM_BEGIN[0] = 0;
  OPTIMAL_COST_TO[0] = 0; 
  std::deque< std::pair<long long int,long long int> > window; 
  window.push_back(std::make_pair(0,0));

  for (int i = 1; i <= n; ++i) {
     OPTIMAL_COST_TO[i] = LLONG_MAX;
    

     while(!window.empty() && window.front().second < DISTANCE_FROM_BEGIN[i] - b) 
       window.pop_front();

      if(window.empty())
      {
        printf("NIE");
        return 0;
      }
     COST[i] += window.front().first; 

     while (!window.empty() && window.back().first >= COST[i] )
       window.pop_back();
    
    window.push_back(std::make_pair(COST[i], DISTANCE_FROM_BEGIN[i]));

    if(l - DISTANCE_FROM_BEGIN[i] <= b && COST[i] < RESULT)
    {
         RESULT = COST[i];
    }     
  }
  
 
  if(RESULT == LLONG_MAX)
      printf("NIE");
  else
      printf("%lld", RESULT);
  return 0;
}
