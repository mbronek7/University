#include <iostream>
#include "stack.h"
using namespace std;
int main()
{
    stack s1 = { 1, 2, 3, 4, 5 };
    stack s2 = s1; // Copy constructor.
// j is not size_t, because multiplying size_t with itself is
// unnatural:
    for( unsigned int j = 0; j < 20; ++ j )
        s2. push( j * j );
        cout<< s2 <<endl;

// Assignment.

// Always check for self assignment.
   s1 = { 100,101,102,103 };
   cout << s1 << "\n";

   stack s3;
	for(int i = 0; i < 10; i++) s3.push(i);
	cout << s3 << endl;
// Works because the compiler inserts constructor and
// calls assignment with the result.
#if 0
// Won’t compile. In order to get it compiled, remove const:
    const stack& sconst = s1;
    sconst. top( ) = 20;
    sconst. push(15);
#endif
}
std::ostream& operator << ( std::ostream& stream, const stack& s )
{
    for( size_t i = 0; i < s. current_size; ++ i )
        stream << " " << s. tab[i];
    return stream;
}
