#include <iostream>
#include "stack.h"
using namespace std;

void stack::ensure_capacity( size_t c )
{
    if( current_capacity < c )
    {
// New capacity will be the greater of c and
// 2 * current_capacity.
        if( c < 2 * current_capacity )
            c = 2 * current_capacity;
        double* newtab = new double[ c ];
        for( size_t i = 0; i < current_size; ++ i )
            newtab[i] = tab[i];
        current_capacity = c;
        delete[] tab;
        tab = newtab;
    }
}

  stack::stack( std::initializer_list<double> d ): current_size{0}, current_capacity{d.size()},tab{new double[d.size()]}
  {

          for( double i : d  )
          {
            tab[current_size] = i;
            current_size++;
          }

  }
void stack::operator = (const stack &s)
{
    if(s.tab == tab) return;
    delete[] tab;
    tab = new double[s.current_capacity];
    current_size = s.current_size;
    current_capacity = s.current_capacity;

    for(size_t i = 0; i < s.current_size; i++)
        tab[i] = s.tab[i];
}

void stack::push( double d )
{
    ensure_capacity( current_size + 1 );
    tab[current_size] = d;
    current_size++;
}

void stack::pop()
{
    //if(current_size > 0)
        current_size--;
    //else
    //    throw std::runtime_error("stack is empty");
}


void stack::reset( size_t s )
{
  //opt
  if(s<=current_size)
  current_size = s;
  else
  throw std::runtime_error("s is bigger than current_size");
}

double& stack::top( )
{
    return tab[current_size-1];
}

double stack::top( ) const
{
    return tab[current_size-1];
}
