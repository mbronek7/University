#include "rational.h"

// Complete these methods:

int rational::gcd( int n1, int n2 )
{
  if(n2 < n1){
    int c = n1;
    n1 = n2;
    n2 = c;
  }
  while(n2 != 0)
  {
    int c  = n1 % n2;
    n1 = n2;
    n2 = c;
  }
  return n1;
}

void rational::normalize( )
{
 if (denum == 0) puts("ERROR: you try to divide by zero!");

 int d_gcd = rational::gcd(num, denum);
    denum /= d_gcd;
    num /= d_gcd;
    if(0>denum)
    {
    denum*=-1;
    num*=-1;
    }
}

rational operator - ( rational r )
{
  r.num *= -1;
  return r;
}

rational operator + ( const rational& r1, const rational& r2 )
{
  rational C;
  int r1n = r1.num, r1d = r1.denum, r2n = r2.num, r2d = r2.denum;
	C.num = r1n*r2d + r1d*r2n;
  C.denum = r1d*r2d;
  return C;
}

rational operator - ( const rational& r1, const rational& r2 )
{
  return  r1 + (-r2);
}

rational operator * ( const rational& r1, const rational& r2 )
{
  rational C;
  C.num = r1.num * r2.num;
  C.denum = r1.denum * r2.denum;
  return C;
}

rational operator / ( const rational& r1, const rational& r2 )
{
  int a,b,c,d;
  a=r1.num;
  b=r1.denum;
  c=r2.num;
  d=r2.denum;
  rational C;
  C.num = a * d;
  C.denum = b *c;
  return C;
}

bool operator == ( const rational& r1, const rational& r2 )
{
    rational C;
    C = r1 - r2;
    if(C.num == 0 )
  	return true;
    return false;
}
bool operator != ( const rational& r1, const rational& r2 )
{
  rational C;
  C = r1 - r2;
  if(C.num != 0 )
  return false;
  return true;
}

std::ostream& operator << ( std::ostream& stream, const rational& r )
{
  stream << r.num << " / " << r.denum;
	return stream;
}
