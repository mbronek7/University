#include <iostream>
#include <stdint.h>

void secret(int *to, int *from, size_t count) 
{
  static const void *labels[] = { &&c0, &&c1, &&c2, &&c3, &&c4, &&c5, &&c6, &&c7 };
  size_t n = (count + 7) / 8;
  size_t m = count % 8;
  int b;
  goto *labels[m];
    c0: *to++ = *from++;
    c7: *to++ = *from++;
    c6: *to++ = *from++;
    c5: *to++ = *from++;
    c4: *to++ = *from++;
    c3: *to++ = *from++;
    c2: *to++ = *from++;
    c1: *to++ = *from++;
  b = --n > 0;
  if (b) goto c0;
}

int main() {
  int from[12] = {1,2,3,4,5,6,7,8,9,10,11,12};
  int to[12] = {4,4,4,4,4,4,4,4,4,4,4,4};
  secret(to, from, 3);
  for(int i=0;i<12;i++)
  std::cout<<to[i]<<" ";
}
