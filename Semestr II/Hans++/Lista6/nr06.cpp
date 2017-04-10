
#include <fstream>
#include <iostream>
#include <random>

#include "listtest.h"
#include "vectortest.h"
#include "timer.h"


int main( int argc, char* argv [] )
{

   std::vector< std::string > vect;

   std::cout << vect << "\n";

   // Or use timer:

   auto t1 = std::chrono::high_resolution_clock::now( ); 
   vectortest::sort_move( vect );
   auto t2 = std::chrono::high_resolution_clock::now( );

   std::chrono::duration< double > d = ( t2 - t1 );
   std::cout << vect << "\n";

   std::cout << "sorting took " << d. count( ) << " seconds\n";
   return 0;
}


