
#ifndef STRING_INCLUDED
#define STRING_INCLUDED 1

#include <iostream>
#include <cstring>

class string
{
    size_t len;
    char *p;

public:
    string( )
        : len{0},
          p{ nullptr }   // Works, see the slides.
    { }

    string( const char* s )
        : len{ strlen(s) },
          p{ new char[ len ] }
    {
        for( size_t i = 0; i < len; ++ i )
            p[i] = s[i];
    }

    string( const string& s )
        : len{ s. len },
          p{ new char[ len ] }
    {
        for( size_t i = 0; i < len; ++ i )
            p[i] = s.p[i];
    }
//my constructor

    string( const string& s1, const string& s2 )
        : len{ s1. len + s2. len },
          p{ new char[ s1. len + s2. len ] }
    {
        for( size_t i = 0; i < s1. len; ++ i )
            p[i] = s1.p[i];

        for( size_t i = 0; i < s2. len; ++ i )
            p[ i + s1. len ] = s2.p[i];
    }
    void operator = ( const string& s )
    {
        if( len != s.len )
        {
            delete[] p;
            len = s. len;
            p = new char[ len ];
        }

        for( size_t i = 0; i < len; ++ i )
            p[i] = s.p[i];
    }

    size_t size( ) const {
        return len;
    }

    ~string( )
    {
        delete[] p;
    }
// my solution start
    char operator [] ( size_t i ) const {
        return p[i];
    }
    char& operator [] ( size_t i ) {
        return p[i];
    }
    void operator += ( char c )
    {
        char *d = new char [ len+1 ];
        for(size_t i=0; i<len; ++i)
            d[i] = p[i];
        d[len] = c;
        delete[] p;
        p = d;
        len++;
        //delete[] d;
    }
    void operator += ( const string& s )
    {
        size_t length = s.len + len;
        char *d = new char [ length ];
        for(size_t i=0; i<len; ++i)
            d[i]=p[i];
        for(size_t i=0; i<s.len; ++i) {
            d[i + len]=s[i];
        }
        delete[] p;
	p = d;
	len = length;
/*
        p = new char [ length ];
        for(size_t i=0; i<length; ++i) {
            p[i] = d[i];
        }
        delete[] d;
        len = length;//

*/
    }

    using iterator = char* ;
    using const_iterator = const char* ;
    const_iterator begin( ) const {
        return p;
    }
    const_iterator end( ) const {
        return p + len;
    }
    iterator begin( ) {
        return p;
    }
    iterator end( ) {
        return p + len;
    }

};
   string operator + (const  string& s1, const string& s2 );

  bool operator == ( const string& s1, const string& s2 );
  bool operator != ( const string& s1, const string& s2 );
  bool operator < ( const string& s1, const string& s2 );
  bool operator > ( const string& s1, const string& s2 );
  bool operator <= ( const string& s1, const string& s2 );
  bool operator >= ( const string& s1, const string& s2 );

std::ostream& operator << ( std::ostream& out, const string& s );

#endif



