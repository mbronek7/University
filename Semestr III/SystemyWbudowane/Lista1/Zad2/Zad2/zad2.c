//MICHAŁ BRONIKOWSKI
#include <avr/io.h> 
#include <util/delay.h>

#define BTN  0x4//0b00000100
#define LED  0x8//0b00001000
#define BTN_PIN PIND
#define BTN_PORT PORTD
#define LED_DDR DDRD
#define LED_PORT PORTD  
#define STATES 100
#define WAITTIME 10

int i = 0;
int  bufor[STATES] = {0};

int main(void) {
    BTN_PORT |= BTN;
    LED_DDR  |= LED;
    while (1) {
    if(bufor[i])
     LED_PORT |=  LED;
    else
     LED_PORT &= ~ LED;
    if(BTN_PIN & BTN)
        bufor[i] = 1;
    else
        bufor[i] = 0;
     i++;
     i %= 100;
    _delay_ms(WAITTIME);


    }
}




