
#include "vectortest.h"

#include <random>
#include <chrono>
#include <algorithm>

std::vector< std::string >
vectortest::randomstrings( size_t nr, size_t s )
{
    static std::default_random_engine gen(
        std::chrono::system_clock::now( ). time_since_epoch( ). count( ) );
    // Narrowing long int into int, but that is no problem.

    static std::string alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345689";
    static std::uniform_int_distribution<int> distr( 0, alphabet. size( ) - 1);
    // More narrowing.

    std::vector< std::string > res;

    for( size_t i = 0; i < nr; ++ i )
    {
        std::string rand;
        for( size_t j = 0; j < s; ++ j )
        {
            rand. push_back( alphabet[ distr( gen ) ] );
        }

        res. push_back( std::move( rand ));
    }
    return res;
}

std::vector<std::string>
vectortest::readfile( std::istream& input )
{
    std::string word;
    std::vector< std::string > vect;
    if( !input.good() ) return vect;

    while( input.good() )
    {
        int c = input.get();

        if(isspace(c) || ispunct(c) || !isprint(c))
        {
            if(!word.empty()) vect.push_back(word), word = "";
        }
        else word += static_cast<char>(c);
    }

    if(!word.empty()) vect.push_back(word);
    return vect;
}

void vectortest::sort_assign( std::vector< std::string > & v )
{
     for( auto j = v. begin( ); j != v. end( ); ++ j )
        for( auto i = v. begin( ); i != j; ++ i )
        {
            if( *i > *j )
            {
                std::string s = *i;
                *i = *j;
                *j = s;
            }
        }
}

void vectortest::sort_move( std::vector< std::string > & v )
{

    for( auto j = v. begin( ); j != v. end( ); ++ j )
    {
        for( auto i = v. begin( ); i != j; ++ i )
        {
            if( *i > *j )
                std::swap( *i, *j );
        }
    }
}

void vectortest::sort_std( std::vector< std::string > & v )
{
      std::sort( v. begin( ), v. end( ));
}


std::ostream&
operator << ( std::ostream& out, const std::vector< std::string > & vect )
{
    for(auto &i : vect) out << i << "\n";
    return out;
}

