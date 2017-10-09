
#include <avr/io.h>  
#include <util/delay.h>  
  
#define LED1 PD0 
#define LED2 PD1
#define LED3 PD2 
#define LED4 PD3 



int main()  
{  
    
    DDRB  |= (1<<LED1) | (1<<LED2) | (1<<LED3) | (1<<LED4) ; //Ustawienie pinów 
                                         
      
   while (1) 
   {  
        PORTB ^=(1<<LED4);
         _delay_ms(100); 
        PORTB ^=(1<<LED4); //Gasze diode nr 4 
        PORTB ^=(1<<LED3); //Zapalam diode nr 3 
         _delay_ms(100); 
        PORTB ^=(1<<LED3); //Gasze diode nr 3 
        PORTB ^=(1<<LED2); //Zapalam diode nr 2 
         _delay_ms(100);
        PORTB ^=(1<<LED2); //Gasze diode nr 2
        PORTB ^=(1<<LED1); //Zapalam diode nr 1 
         _delay_ms(100); 
        PORTB ^=(1<<LED1);  // Gasze diode nr 1
         
    }  
    return 0;
}  
