#include "string.h"

std::ostream& operator << ( std::ostream& out, const string& s )
{
   for( char c : s )
      out << c;
   return out; 
}




