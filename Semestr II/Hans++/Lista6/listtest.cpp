
#include "listtest.h"

#include <random>
#include <chrono>
#include <algorithm>

std::ostream& operator << ( std::ostream& stream, const std::list< std::string > & L)
{
    for(auto &i : L) stream << i << "\n";
    return stream;
}

void listtest::sort_move( std::list< std::string > & v )
{
    for( auto q = v. begin( ); q != v. end( ); ++ q )
    {
        for( auto p = v. begin( ); p != q; ++ p )
        {
            if( *p > *q )
            {
                std::string s = *p;
                *p = *q;
                *q = s;
            }
        }
    }
}

void listtest::sort_assign( std::list< std::string >  & v )
{
    for( auto q = v. begin( ); q != v. end( ); ++ q )
	{
		for( auto p = v. begin( ); p != q; ++ p )
		{
			if( *p > *q )
			{
				std::string s = *p;
				*p = *q;
				*q = s;
			}
		}
    }
}


