
#include "fifteen.h"
//konstruktor na liscie inicjowanej
fifteen::fifteen( std::initializer_list< std::initializer_list< size_t > > init )
{
	size_t i = 0, j = 0;

	for(auto it_i = init.begin(); i < dimension && it_i != init.end(); ++i, ++it_i) //ma byc mniejsze od wymiaru i od konca listy
	{
		j = 0;

		for(auto it_j = (*it_i).begin(); j < dimension && it_j != (*it_i).end(); ++j, ++it_j)// uzupelnianie tablicy 2 wymiarowej
		{
			table[i][j] = *it_j;
			if(*it_j == 0) open_i = i, open_j = j;
		}
	}
}
//// Konstruktor korzystający z : Position of the open place. Use matrix notation, i is row,
// j is column.
// We use the numbers 1 .. dimension*dimension-1 for the tiles,
// and 0 for the open place.

fifteen::fifteen( ) : open_i{dimension-1}, open_j{dimension-1}
{
	for(size_t i = 0; i < dimension; ++i)
	{
		for(size_t j = 0; j < dimension; ++j)
			table[i][j] = dimension*i + j+1;
	}

	table[dimension-1][dimension-1] = 0;
}


std::ostream& operator << ( std::ostream& stream, const fifteen& f ) // operator << zwykłe wypisywanie tablicy 2 wymiarowej
{
	for(size_t i = 0; i < f.dimension; ++i)
	{
		for(size_t j = 0; j < f.dimension; ++j)
		{
			stream << f.table[i][j] << "\t";
		}

		stream << "\n";
	}

	return stream;
}
//Koniec zadania 1

//Zadanie 2
size_t fifteen::hashvalue( ) const
{
	size_t w = 0;
	const size_t k = 99999999997;

	for(size_t i = 0; i < dimension; ++i)
	{
		for(size_t j = 0; j < dimension; ++j)
		{
			 size_t w1 = ( (i+3) * 17 + (j + 7) * 29);
			 size_t w2 = i + j + 41;
			 w = (( (w+w1) % k ) * w2) % k;
		}
	}

	return w;
}
//
bool fifteen::equals( const fifteen& other ) const // porownywanie 2 tablic dwu wymiarowyc
{
	for(size_t i = 0; i < dimension; ++i)
	{
		for(size_t j = 0; j < dimension; ++j)
		{
			if(table[i][j] != other.table[i][j]) return false;
		}
	}

	return true;
}
//
void fifteen::makemove(move p)
{
	size_t x = open_i, y = open_j;

 switch (p) {
    case move::left:
      if (y == 0) throw illegalmove(p);  // jak y = 0 to nie mozna juz isc w leweo
      else {
        std::swap(table[x][y], table[x][y-1]); // zamieniam klocki miejscami
        open_j -= 1; // kolumna sie zmienia
      }
      break;
    case move::up:
      if (x == 0) throw illegalmove(p); // nie mozna pojsc wyzej
      else {
        std::swap(table[x][y], table[x-1][y]); // zamieniam klocki miejscami
        open_i -= 1; // zmienia sie wers
      }
      break;
    case move::down:
      if (x == dimension-1) throw illegalmove(p); // na dole ogranicza nas wymiar planszy -1
      else {
        std::swap(table[x][y], table[x+1][y]);// zamieniam klocki miejscami
        open_i += 1; // zmienia sie wers
      }
      break;
    case move::right:
      if (y == dimension-1) throw illegalmove(p); // na prawo ogranicz nas wymioar planszy -1
      else {
        std::swap(table[x][y], table[x][y+1]);// zamieniam klocki miejscami
        open_j += 1; // kolumna sie zmienia
      }
      break;
  }

}
//
bool fifteen::issolved( ) const
{
	return distance() == 0; // jak dystans pomiedzy dwoma liczbami bedzie rowny 0 to kostki sa juz ulożone
}
//
size_t fifteen::distance( ) const
{
	int  dist = 0;  // wartosc poczatkowa

	for(size_t i = 0; i < dimension; ++i) // for po całym wymiarze planszy
	{
		for(size_t j = 0; j < dimension; ++j) // 2 wymiar tablicy
		{
			auto p = solvedposition(table[i][j]);

			dist += distance(p,{i,j}); // korzystam z funkcji z fifteen.h
		}
	}

	return dist;
}
//
using position = std::pair< size_t, size_t > ;
position fifteen::solvedposition( size_t val )
{
	std::pair< size_t, size_t > p = std::make_pair((val-1)/dimension, (val-1) % dimension);
	if(val==0) p = std::make_pair(dimension-1, dimension-1);
	return p;
}
