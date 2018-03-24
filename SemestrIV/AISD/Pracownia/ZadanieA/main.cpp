//MICHAL BRONIKOWSKI, 292227 
#include <iostream>
#include <stack>
#define MAX  1000007
std::stack<int> S;
std::stack<int> S2;
int first[MAX];
int neighbours[MAX];
int n, t, step, a, b, q;
void DFS(int);
struct ver{
   int in=0;
   int out=0;
};
ver *vertex;
struct par{
   int of=0;
   int father=0;
};
par *parent;
int k=-1,s;
int main(void)
{
    std::ios::sync_with_stdio(false);
    std::cin.tie(NULL);
    
    std::cin>>n>>q;
    vertex = new ver[n+1];
    parent = new par[n+1];
    for (int i = 2; i <= n; ++i)
    {
        std::cin>>t;
        neighbours[i] = first[t];
        first[t] = i;
    }

    DFS(1);
 
    for(int i=0;i<q;++i)
    {
       std::cin>>a>>b;
       if(vertex[a].in < vertex[b].in && vertex[a].out > vertex[b].out) std::cout<<"TAK\n";
       else std::cout<<"NIE\n"; 
       
    }
    return 0;
}

void DFS(int v)
{
     vertex[v].in = ++step;
     S.push(v);
     while ( !S.empty() ) {
       v = S.top(); S.pop();vertex[v].in = step;//std::cout<<"ide do: "<<v<<"\n";
       int actual = first[v];step++;
        if(actual !=0 )
        while (actual != 0)
        {
           
            if(vertex[actual].in == 0){
            S.push(actual);
            parent[actual].father = v;
            parent[v].of++;

            }
            actual = neighbours[actual];
            S2.push(v);
        }
       
       else{
        vertex[v].out = ++step;
        k = parent[v].father;
        parent[k].of--;//std::cout<<"Jestem z :"<<v<<"ojciec: "<<k<<"ma dzieci oprocz mnie: "<< parent[k].of<<"\n";
        while(parent[k].of == 0)
         {
              vertex[k].out = ++step;
              k = parent[k].father;
              parent[k].of--;
         }
     }
  }
       while ( !S2.empty() && k!=s ) {
             k = S2.top();S2.pop();
          if(vertex[k].out == 0){
           vertex[k].out=++step;
            }
       }

}
