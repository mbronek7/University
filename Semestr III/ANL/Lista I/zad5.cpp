#include<cmath>
#include<cstdio>

long double calc(int x,int k)
{
    long double sum = 0;
    for (int i=1;i<=k;++i)
        sum+=pow((-1),(i-1)) *long  double((pow((x-1),i) / i));
    return sum;
}

long double ln(int x)
{
  double arg = x / M_E;
  return 1 + calc(arg,1);
}

int main()
{
    printf("%lf",calc(10,2000));
    return 0;
}
