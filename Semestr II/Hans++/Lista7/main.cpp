#include <iostream>
#include <map>
#include <unordered_map>
#include <string>
#include <vector>
#include <cstdio>
#include <fstream>
using namespace std;



struct case_insensitive_cmp 
{
	bool operator( ) ( const std::string& string1, const std::string& string2 ) const
	{
		auto p2 = string2.begin();

		for(auto p1 = string1.begin(); p1 != string1.end(); ++p1)
		{
			if(p2 == string2.end()) return false;
			if(tolower(*p1) < tolower(*p2)) return true;
			if(tolower(*p1) > tolower(*p2)) return false;
			p2++;
		}

		if(p2 != string2.end()) return true;
		return false;
	}
};

template< typename C = std::less< std::string >>map< std::string, unsigned int, C >frequencytable( const std::vector< std::string > & text )

{
	map<string, unsigned int, C > mapa;
	for( auto iter = text.begin(); iter != text.end(); ++iter ) mapa[*iter]++;
	return mapa;
}


template< typename C >std::ostream& operator << ( std::ostream& stream,const std::map< std::string, unsigned int, C > & frq)

{
	for ( const auto &p : frq ) stream  << p.first << '\t' << p.second << "\n";
	return stream;
}

struct case_insensitive_hash
{
	size_t operator () ( const std::string& s) const
	{
		size_t w = 0;
		
		for(size_t i = 0; i < s.size(); i++)
		{
			w = (w * 29)%1000000007 + (tolower(s[i]) - 'a' + 1);
			w %= 1000000007;
		}

		return w;
	}
};

struct case_insensitive_equality
{
	bool operator( ) ( const std::string& string1, const std::string& string2 ) const
	{
		case_insensitive_cmp c;
		return !c(string1,string2) && !c(string2,string1);
	}
};


using maptype = std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality > ;

maptype frequencytable_hash( const std::vector<std::string > & text )
{
	std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality > mapa;
	for( auto iter = text.begin(); iter != text.end(); ++iter ) mapa[*iter]++;
	return mapa;
}


std::vector< std::string> readfile( std::istream& input )
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
      


int main()
{
	
	cout << frequencytable< case_insensitive_cmp >(vector<string> {"AA", "aA", "Aa", "this", "THIS"});
	case_insensitive_cmp c;
	cout << c("a", "A") << " " << c("a", "b") << " " << c("A", "b") << "\n";
	puts("\nunordered_map : \n");
	auto M = frequencytable_hash(vector<string> {"Aa","aa", "bb", "Cab"} );
	case_insensitive_hash h;
	cout << h("xxz") << " " << h("XXX") << "\n";
	cout << h("Abc") << " " << h("abC") << "\n";
	case_insensitive_equality e;
	std::cout << e("xxx", "XXX") << "\n";
	cout<<"\nThe first book of ‘Confessiones’ : \n";
    ifstream is("a.txt");
    auto x = frequencytable< case_insensitive_cmp >(readfile(is));
    cout<<"magnum -- "<<x["magnum"]<<endl;
    cout<<"homonium -- "<<x["homonium"]<<endl;
    cout<<"memoria -- "<<x["memoria"]<<endl;

	return 0;
}

