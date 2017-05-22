
#include "powerproduct.h"
#include <algorithm>


std::ostream& operator << ( std::ostream& out, const powvar & p )
{
   if( p.n == 0 )
   {
      out << "1"; // Should not happen, but we still have to print something.
      return out;
   }

   out << p.v;
   if( p.n == 1 )
      return out;

   if( p.n > 0 )
      out << "^" << p.n;
   else
      out << "^{" << p.n << "}";
   return out;
}

bool operator < (const powvar& a, const powvar& b)
{
    return a.v < b.v;
}

powerproduct operator*(powerproduct c1, const powerproduct & c2)
{
	c1.repr.insert(c1.repr.end(), c2.repr.begin(), c2.repr.end()); // tak jak w tresci łącze je w jeden w sposob taki ze na koniec pierwszego wkladam drugi

	c1.normalize(); // normalizuje
	return c1;   // i zwracam wynik
}

std::ostream& operator << ( std::ostream& out, const powerproduct& c )
{
   if( c. isunit( ))
   {
      out << "1";
      return out;
   }

   for( auto p = c. repr. begin( ); p != c. repr. end( ); ++ p )
   {
      if( p != c. repr. begin( ))
         out << ".";
      out << *p;
   }

   return out;
}


int powerproduct::power( ) const
{
   int p = 0;
   for( auto pv : repr )
      p += pv. n;
   return p;
}

int powerproduct::compare(const powerproduct & c1, const powerproduct & c2)
{
	int expSum1 = 0;
	for (size_t i = 0; i < c1.repr.size(); i++)
	{
		expSum1 += c1.repr[i].n;
	}

	int expSum2 = 0;
	for (size_t i = 0; i < c2.repr.size(); i++)
	{
		expSum2 += c2.repr[i].n;
	}
 // Podział na 3 przypadki do porownania jak suma jak sa rown etopotem po rozmiarze i na koncu alfabetycznie
	if (expSum1 < expSum2) return -1;
	if (expSum1 > expSum2) return 1;

	if (c1.repr.size() < c2.repr.size()) return -1;
	if (c1.repr.size() > c2.repr.size()) return 1;

	// alfabetycznie
	int n = c1.repr.size();
	for (size_t i = 0; i < n; i++)
	{
		if (c1.repr[i].n < c2.repr[i].n)
			return -1;

		if (c1.repr[i].n > c2.repr[i].n)
			return 1;
	}

	return 0;
}

void powerproduct::normalize() // SORT JEST LOG(N) DO TEO 2 * N WIEC W SUMIE JEST NIE GORSZE NIZ N * LOG(N)
{
	if (repr.empty()) return; // jak jest puste to jest juz znormalizowane

	sort(repr.begin(), repr.end()); // sortuje ten wektor z klasy
	for (size_t i = 0; i < repr.size() - 1;)
	{
		if (repr[i].v == repr[i + 1].v) //  jak mamy x^i * x^j = x^( i + j ) i jeden z nich usuwam ten drugi
		{
			repr[i].n += repr[i + 1].n;
			repr.erase(repr.begin() + i + 1);
		}
		else
		{
			i++;
		}
	}

	for (size_t i = 0; i < repr.size(); i++)
	{
		if (repr[i].n == 0)
			repr.erase(repr.begin() + i);  //jak stopien jest rowny zero to tez usuwam

	}
}
