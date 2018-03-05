#include <iostream>
#include <stdint.h>

struct A {
 int8_t a;
 void *b;
 int8_t c;
 int16_t d;
} a;

struct A2 {
 void *b;
 int16_t d;
 int8_t a;
 int8_t c;
} a2;

struct B{
    uint16_t a;
    double b;
    void *c;
}b;

struct B2{
    double b;
    void *c;
    uint16_t a;
}b2;

int main()
{ 
  std::cout<<sizeof(a)<<"\n";
  std::cout<<sizeof(a2)<<"\n";
  std::cout<<sizeof(b)<<"\n";
  std::cout<<sizeof(b2)<<"\n";
  return 0;
}
