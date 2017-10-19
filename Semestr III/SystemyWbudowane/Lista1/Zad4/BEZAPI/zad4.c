// ------- Preamble -------- //
#include <avr/io.h>
#include <util/delay.h>
#include "USART.h"

#define BUZZER  0x8//0b00000100
#define LED     0x4//0b00001000
#define LED_DDR DDRD
#define LED_PORT PORTD 
#define BUZZER_DDR DDRD
#define BUZZER_PORT PORTD 

const char MorseCodeForCharsAndDigits[][8] = { 
  {'a','.','-' ,'~'},
  {'b','-', '.', '.', '.', '~'},
  {'c', '.', '-', '.', '~'},
  {'d','-','.','.','~'},
  {'f','-', '.', '.', '~'},
  {'e','.', '~'},
  {'f','.', '.', '-', '.', '~'},
  {'g','-', '.', '.', '~'},
  {'h','.', '.', '.', '.', '~'},
  {'i','.', '.', '~'},
  {'j','.', '-', '-', '-', '~'},
  {'k','-', '.', '-', '~'},
  {'l','.', '-', '.', '.', '~'},
  {'m','-', '-', '~'},
  {'n','-', '.', '~'},
  {'o','-', '-', '-', '~'},
  {'p','.', '-', '-', '.', '~'},
  {'q','-', '-', '.', '-', '~'},
  {'r','.', '-', '.', '~'},
  {'s','.', '.', '.', '~'},
  {'t','-', '~'},
  {'u','.', '.', '-', '~'},
  {'w','.', '-', '-', '~'},
  {'v','.', '.', '.', '-', '~'},
  {'x','-', '.', '.', '-', '~'},
  {'y','-', '.', '-', '~'},
  {'z','-', '-', '.', '.', '~'},
  {'1','.', '-', '-', '-', '-', '~'},
  {'2','.', '.', '-', '-', '-', '~'},
  {'3','.', '.', '.', '-', '-', '~'},
  {'4','.', '.', '.', '.', '-', '~'},
  {'5','.', '.', '.', '.', '.', '~'},
  {'6','-', '.', '.', '.', '.', '~'},
  {'7','-', '-', '.', '.', '.', '~'},
  {'8','-', '-', '-', '.', '.', '~'},
  {'9','-', '-', '-', '-', '.', '~'},
  {'0','-', '-', '-', '-', '-', '~'}
};
const int Size = sizeof (MorseCodeForCharsAndDigits) / sizeof (MorseCodeForCharsAndDigits)[0] ;

char String [100];
uint8_t maxLength = 99;
int main(void) {
    initUSART();
    BUZZER_DDR |= BUZZER;
    LED_DDR  |= LED;

 while (1) {
   printString("Wpisz tekst do przetlumaczenia na kod Morse'a:\r\n"); 
   readString(String,maxLength);
   printString(String);
   printString(":\r\n");

    for(int j = 0;j < strlen(String);j++){ 
    char Char_to_morse = tolower(String[j]);
   transmitByte(String[j]);
    for (int i = 0; i < Size; i++) {
      
      if (Char_to_morse == MorseCodeForCharsAndDigits[i][0])
      { 
          printString(" ---   "); 
        
        for (int j = 1; j < 7; j++) 
        { 
          
          if (MorseCodeForCharsAndDigits[i][j] == '.') 
          { 
            LED_PORT |=  LED;
            BUZZER_PORT |= BUZZER; 
            _delay_ms(100); 
            LED_PORT &= ~ LED;
            BUZZER_PORT &= ~ BUZZER;
            _delay_ms(100); 
           printString(" * ");
          }
          else if (MorseCodeForCharsAndDigits[i][j] == '-') 
          { 
             
            LED_PORT |=  LED; 
            BUZZER_PORT |= BUZZER; 
            _delay_ms(300); 
          LED_PORT &= ~ LED;
            BUZZER_PORT &= ~ BUZZER;
            _delay_ms(100); 
            printString(" - ");
          }
         
          else
          { 
            _delay_ms(200);   // koniec wysyłania sygnalu jednego znaku
            printString("\r\n");
            break; 
          }
        }        
        break;
      } 
      if(Char_to_morse == ' ')
      {
           printString("\r\n");
           _delay_ms(600); // Koniec wyrazu
           break;
      }
    }
   }
 } 
 return (0);
}
//
//
//
/*
Dane dotyczące czasu nadawania kresek i kropek wziąłem z:
http://www.polskieradio.pl/39/246/Artykul/852119,Alfabet-Morse%E2%80%99a-%E2%80%93-rewolucja-telegraficzna
*/


