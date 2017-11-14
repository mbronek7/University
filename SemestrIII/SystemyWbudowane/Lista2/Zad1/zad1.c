#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <math.h>
#define _BV(bit) (1<<(bit))

struct RgbColor
{
     uint16_t r;
     uint16_t  g;
     uint16_t   b;
} led;

int tab[] =  {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8, 9, 9, 10, 11, 12, 12, 13, 14, 16, 17, 18, 19, 21, 22, 24, 25, 27, 29, 31, 34, 36, 39, 42, 45, 48, 51, 55, 59, 63, 68, 73, 78, 84, 90, 97, 103, 111, 119, 127, 137, 147, 157, 168, 181, 194, 207, 222, 238, 255};

const int Size = sizeof (tab) / sizeof (tab)[0] ;

void HsvToRgb(uint8_t H, uint16_t  *R,uint16_t *G,uint16_t *B) {

    uint16_t region = H /43;
    uint16_t remainder = (((uint16_t)H)<<8)/43 & 0x00FF;

   
    uint16_t q = 0x0100 - remainder;
    uint16_t t = remainder;
    switch(region) {
    case 0:
        *R = 0x0100, *G = t, *B = 0;
        break;
    case 1:
        *R = q, *G = 0x0100, *B = 0;
        break;
    case 2:
        *R = 0, *G = 0x0100, *B = t;
        break;
    case 3:
        *R = 0, *G = q, *B = 0x0100;
        break;
    case 4:
        *R = t, *G = 0, *B = 0x0100;
        break;
    case 5:
        *R = 0x0100, *G = 0, *B = q;
        break;
    }

}
/*
if(val==0) {red=0; grn=0; blu=0;}
else{
 H/=60;
 i = Math.floor(H);
 f = H-i;
 p = 1*(1-1);
 q = 1*(1-(1*f));
 t = 1*(1-(1*(1-f)));
 if (i==0) {red=val; grn=t; blu=p;}
 else if (i==1) {red=q; grn=val; blu=p;}
 else if (i==2) {red=p; grn=val; blu=t;}
 else if (i==3) {red=p; grn=q; blu=val;}
 else if (i==4) {red=t; grn=p; blu=val;}
 else if (i==5) {red=val; grn=p; blu=q;}
}
*/
void startled()
{
	    uint16_t h;
        h = rand()%255;;
        HsvToRgb(h,&led.r,&led.g,&led.b);
		
		for(unsigned char i = 1;i<Size;i++)
		{
			OCR2A = ((uint8_t)((tab[i]*led.r) >>8));
			OCR0A = ((uint8_t)((tab[i]*led.g) >>8));
			OCR0B = ((uint8_t)((tab[i]*led.b) >>8));
			_delay_ms(30);
		}
		
		
		
		for(unsigned char i = Size-1;i>0;i--)
		{
			OCR2A = ((uint8_t)((tab[i]*led.r) >>8));
			OCR0A = ((uint8_t)((tab[i]*led.g) >>8));
			OCR0B = ((uint8_t)((tab[i]*led.b) >>8));
			_delay_ms(30);
		}
		
}
int main (void)
{
	DDRB = 0x08;
	DDRD = 0x60;
	
	TCCR0A |= (1<<WGM00)|(1<<WGM01)|(1<<COM0A1)|(1<<COM0B1);
	TCCR0B =_BV(CS00);	
	TCCR2A |= _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20); 
	TCCR2B = _BV(CS20);

	
	while(1)
	{
	startled();	 
	}
	return 0;
}
