#include <avr/io.h>
#include <util/delay.h>
#define START 0x2//0b0000010
#define BREAK 0x8//0b0001000
#define END   0x40//0b1000000
#define TIME 100
int main()
{
  DDRD  = 0xFC;//0b11111100;
  PORTD = START;
  while (1)
  {

       PORTD = START;
  //
      for(int i = PORTD; i <= END; i = i << 1)
      {
       PORTD = PORTD << 1;
      _delay_ms(TIME);
      }

      for(int i = PORTD; i > BREAK; i = i >> 1)
      {
         PORTD = PORTD >> 1;
         _delay_ms(TIME);
      }
  }
}
