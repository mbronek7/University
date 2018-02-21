#ifndef TREE_INCLUDED
#define TREE_INCLUDED  1

#include <iostream>
#include <vector>
#include "string.h"

class tree;

// struct trnode should be invisible to the user of tree. This can be
// obtained by making it a private number of tree.
// In this exercise, we leave it like this, because it is simpler.
// In real code, trnode should be defined inside tree.


struct trnode
{
  string f;
  std::vector< tree > subtrees;

    size_t refcnt;
    // The reference counter: Counts how often this trnode is referred to.

    trnode( const string& f, const std::vector< tree > & subtrees,
            size_t refcnt )
        : f{f},
          subtrees{ subtrees },
          refcnt{ refcnt }
    { }

    trnode( const string& f, std::vector< tree > && subtrees,
            size_t refcnt )
        : f{f},
          subtrees{ std::move( subtrees )},
          refcnt{ refcnt }
    { }

};

class tree
{

    trnode* pntr;

public:

    tree( const string& f ) : pntr( new trnode( f, { }, 1 )) {}
    tree(const string& f, const std::vector< tree > & subtrees) : pntr(new trnode(f,subtrees,1)) {}
    tree(const string& f, std::vector< tree > && subtrees): pntr(new trnode(f,std::move(subtrees),1)) {}
    
    tree (const tree& t) : pntr(t.pntr) 
    {
        //++pntr->refcnt;
        pntr -> refcnt++;
    }

    void operator = (tree&& t) {
        std::swap(pntr, t.pntr);
      /*  trnode* temp;
        temp = t.pntr;
        t.pntr = pntr;
        pntr = temp;*/
    }

    void operator = ( const tree& t ){*this = tree(t);}

size_t nrsubtrees() const {return pntr -> subtrees.size();}

  ~tree()
{
    pntr->refcnt--;  //usuwanie powiazanych wskaznikow zeby nie bylo wyciekow pamieci
    if(pntr->refcnt == 0) delete pntr;
}
const string& functor() const {return pntr -> f;}


const tree& operator [] (size_t i) const {return pntr->subtrees[i];}
void replacesubtree( size_t i, const tree& t );
void replacefunctor( const string& f );
size_t getaddress( ) const
{
return reinterpret_cast< size_t > ( pntr );
}


private:
void ensure_not_shared( );

tree subst( const tree& t, const std::string& var, const tree& val );

};

std::ostream& operator << ( std::ostream& stream, const tree& t );
   // Doesn't need to be friend, because it uses only functor( ),
   // nrsubtrees( ) and [ ].

#endif