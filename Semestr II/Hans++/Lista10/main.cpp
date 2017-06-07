
#include <iostream>

#include "units.h"

// Useful if you want to compute the yield of an atomic bomb:

#if 0
quantity::energy mc2( quantity::mass m )
{
   auto C = 299792458.0_mps;   
   return m * C * C;
}
#endif 

int main( int argc, char* argv [ ] )
{
   std::cout << 9.81 * 1.0_m / ( 1.0_sec * 1.0_sec ) << "\n";
      // Acceleration on earth.

   std::cout << 1.0_m << "\n";
   std::cout << 2.0_hr << "\n";
   
   std::cout << 1000.0_watt << "\n";

   return 0;

}


