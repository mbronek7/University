#include "tree.h"
#include "string.h"


std::ostream& operator << ( std::ostream& stream, const tree& t ) 
{ 	
	
       // size_t i = 0;
		stream <<t.functor() << "[" <<t.getaddress() <<"]" <<std::endl;
       /* do								nie dziala dla o potomkow bo wykona sie raz
          {
             stream << t[i] << " ";
             ++i;                                
          } 
          while(i < t.nrsubtrees()); 
		*/
		  for(size_t i=0; i < t.nrsubtrees();++i)
		  {
			  stream <<t[i]<<" ";
		  }
   return stream;
}

void tree::ensure_not_shared()
{
	if (pntr-> refcnt != 1)
	{
		pntr-> refcnt--;
		pntr = new trnode(pntr -> f, pntr -> subtrees, 1);
	}
}


void tree::replacesubtree( size_t i, const tree& t )
{
	if( pntr -> subtrees[i]. pntr != t. pntr )
	{
		ensure_not_shared();
		pntr -> subtrees[i] = t;
	}
}
void tree::replacefunctor( const string& f )
{
	if(pntr ->f != f)
	{
		ensure_not_shared();
		pntr -> f = f;
	}
}
tree subst( const tree& t, const string& var, const tree& val )
{
	if( t. nrsubtrees() == 0 ){
	    if( t. functor() == var ) return val;
	    return t;
	}
		tree temp = t;
		for( size_t i = 0; i < t. nrsubtrees( ); ++ i )
			temp. replacesubtree( i, subst( t[i], var, val ));
		return temp;
	
}