#include "string.h"

std::ostream& operator << ( std::ostream& out, const string& s )
{
   for( char c : s )
      out << c;
   return out; 
}


   bool operator == ( const string& s1, const string& s2 )
    {
        
	if(s2.size() != s1.size()) return false;
for( size_t i = 0; i < s1.size(); i++) {
            if(s1[i] != s2[i]) return false;
        }
        return true;
    }
   bool operator != ( const string& s1, const string& s2 )
    {
        return !(s1==s2);
    }






 string operator + (const  string& s1, const string& s2 )
    {
       // return string( p, s1 );
	string s3 = s1;
        s3 += s2;
	return s3;
    }


  bool operator < ( const string& s1, const string& s2 )
{
	 size_t i = 0;
size_t m = std::min(s1.size(),s2.size());
         while(i < m && s1[i] == s2[i]) ++i;
         if( i == s1.size() ) return true;
         if( i == s2.size() ) return false;
	return (s1[i] < s2[i]);
}
 bool operator > ( const string& s1, const string& s2 )
{
        return s2 < s1;
}

 bool operator <= ( const string& s1, const string& s2 )
{
       return !( s2 > s1);//
}
 bool operator >= ( const string& s1, const string& s2 )
{
       return !( s2 < s1);//
}
