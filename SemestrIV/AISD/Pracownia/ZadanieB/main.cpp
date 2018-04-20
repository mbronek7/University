// MICHAL BRONIKOWSKI, 292227
#include <cstdio>
#include <vector>
#include <utility>
#include <algorithm>
#include <map>

std::vector< std::pair< std::pair<int, int>, std::pair<int, int> > > tunels;
std::map< std::pair<int, int>,std::pair<int,bool> > vertex; // bool if vertex is connected with S-point 
int m, n, t;
int a1, b1, a2, b2;
int roads;
int main()
{
	scanf("%d%d%d",&m,&n,&t);

	for (int i = 0; i<t; ++i) 
	{
		scanf("%d%d%d%d",&a1,&b1,&a2,&b2);
		tunels.push_back(std::make_pair(std::make_pair(a1, b1), std::make_pair(a2, b2)));
	}

	std::sort(tunels.begin(), tunels.end()); 

        vertex[std::pair<int, int>(0,0)].second = true;
	for (auto& i : tunels)
	{    
              if(vertex[std::pair<int, int>(i.first.first, i.first.second)].second)
              {   
		auto it = vertex.find(std::pair<int, int>(i.first.first, i.first.second));
		if (it != vertex.end() && (i.first.first != 0 && i.first.second != 0))
		{
			roads = (it->second.first)%999979;
			auto it2 = vertex.find(std::make_pair(i.second.first, i.second.second));
			vertex[std::pair<int,int>(i.second.first, i.second.second)].second = true;
			if (it2 != vertex.end())
				vertex[std::pair<int, int>(i.second.first, i.second.second)].first = (vertex[std::pair<int, int>(i.second.first, i.second.second)].first + roads)%999979;
                        else
				vertex[std::pair<int, int>(i.second.first, i.second.second)].first = roads;
		}
                else
                {

			auto it2 = vertex.find(std::make_pair(i.second.first, i.second.second));
			vertex[std::pair<int,int>(i.second.first, i.second.second)].second = true;
			if (it2 != vertex.end())
				vertex[std::pair<int, int>(i.second.first, i.second.second)].first = (vertex[std::pair<int, int>(i.second.first, i.second.second)].first + 1)%999979;
                        else
				vertex[std::pair<int, int>(i.second.first, i.second.second)].first = 1;
                }
              }
	}
        printf("%d",vertex[std::pair<int,int>(m,n)].first%999979);
}
