
#ifndef UNITS_INCLUDED 
#define UNITS_INCLUDED  1

#include <iostream>

// I would have preferred to use 'Coulomb' instead of 
// 'Ampere', but 'Coulomb' is not a basic SI-unit.

// Mass/Length/Time/Current.
// kg/m/sec/ampere.

template< int M, int L, int T = 0, int I = 0 >
struct si 
{
   double val;

   explicit si( double val )
      : val{ val }
   { } 
};


// Specialization for <0,0,0,0> has implicit conversion to double:
// This solves the problem of 1.0_kg / 2.0_kg + 2.0, which otherwise
// will not compile: 

template<>
struct si<0,0,0,0>
{
   double val;

   // Constructor can be implicit:

   si( double val )
      : val{ val }
   { }

   // Conversion operator to double:

   operator double( ) const { return val; }
};



template< int M, int L, int T, int I >
std::ostream& operator << ( std::ostream& out, si<M,L,T,I> quant )
{
   std::cout << "good evening\n"; 
   // If you want, you can catch special cases, like Newton/Watt.

   return out; 
}


// Physical Quantities:

namespace quantity
{
   using length = si<0,1,0,0>;
   using speed = si<0,1,-1,0>;
   using mass = si<1,0,0,0>;
   using time = si<0,0,1,0>;
   using force = si<1,1,-2,0 >;
   using charge = si<0,0,1,1 >;
   using current = si<0,0,0,1>;
   using voltage = si<1,2,-3,-1 >;
   using energy = si<1,2,-2,0 >;
   using power = si<1,2,-3,0 >;
}

// Some common units, feel free to add more.

inline quantity::mass operator "" _kg( long double x )
{
   return quantity::mass(x);
}

inline quantity::length operator "" _m( long double x )
{
   return quantity::length(x);
}

inline quantity::time operator "" _sec( long double x )
{
   return quantity::time(x);
}

inline quantity::energy operator "" _joule( long double x )
{
   return quantity::energy(x);
}

inline quantity::power operator "" _watt( long double x )
{
   return quantity::power(x);
}

inline quantity::force operator "" _newton( long double x )
{
   return quantity::force(x);
}

inline quantity::time operator "" _min( long double x )
{
   return quantity::time( 60.0 * x );
}

inline quantity::time operator "" _hr( long double x )
{
   return quantity::time( 3600.0 * x );
}

inline quantity::voltage operator "" _V( long double x )
{
   return quantity::voltage(x);
}

inline quantity::current operator "" _A( long double x )
{
   return quantity::current(x);
}

inline quantity::speed operator "" _mps( long double v )
{
   return quantity::speed(v);
}
  
inline quantity::speed operator "" _kmh( long double v )
{
   return quantity::speed( v / 3.6 );
}

inline quantity::speed operator "" _knot( long double v )
{
   return quantity::speed( v * 0.51444444444444444444444 );
}

 
#endif



