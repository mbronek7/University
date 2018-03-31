//MICHAŁ BRONIKOWSKI
#include <avr/io.h> 
#include <util/delay.h>

#define BTN1  0x4//0b00000100
#define BTN2  0x8//0b00001000
#define BTN3  0x10//0b00010000
#define LED1  0x1//0b00000001
#define LED2  0x2//0b00000010
#define LED3  0x4//0b00000100
#define LED4  0x8//b00001000
#define BTN_PIN PIND
#define BTN_PORT PORTD
#define LED_DDR DDRB
#define LED_PORT PORTB   
#define SIZE 15
int gray = 0;
uint8_t key_lock1,key_lock2,key_lock3;

int main() {
    BTN_PORT |= BTN1 | BTN2 | BTN3;
    LED_DDR  |= LED1 | LED2 | LED3 | LED4 ;
   _delay_ms(10); 
    while (1)
      {
      

             if (!key_lock1 && !(BTN_PIN & BTN1))
              {
              key_lock1=1;
              gray= 0;
              LED_PORT = ((gray ^ (gray >> 1)) ); 
              } else if( key_lock1 && (BTN_PIN & BTN1)) key_lock1++;
              
             if (!key_lock2 && !(BTN_PIN & BTN2))
              {
              key_lock2=1;
              gray = (gray==SIZE) ? 0 : gray + 1;
              LED_PORT = ((gray ^ (gray >> 1)) & LED_DDR);  
              }else if( key_lock2 && (BTN_PIN & BTN2)) key_lock2++;
              
             if (!key_lock3 && !(BTN_PIN & BTN3))
              {
              key_lock3=1;
              gray = (gray==SIZE) ? 0 : gray - 1;
              LED_PORT = ((gray ^ (gray >> 1)) & LED_DDR);
              }else if( key_lock3 && (BTN_PIN & BTN3)) key_lock3++;
        
       }
         
}

