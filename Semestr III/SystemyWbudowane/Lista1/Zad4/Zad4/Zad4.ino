/*

Dane dotyczące czasu nadawania kresek i kropek wziąłem z:

http://www.polskieradio.pl/39/246/Artykul/852119,Alfabet-Morse%E2%80%99a-%E2%80%93-rewolucja-telegraficzna

*/
#define BUZZER  9 
#define LED  8 
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

void setup() {
  
  Serial.begin(9600); 
  while (!Serial)
  {
    ;
  } 
  Serial.println("Wpisz tekst do przetlumaczenia na kod Morse'a:"); 
  pinMode(LED, OUTPUT); 
  pinMode(BUZZER, OUTPUT); 
  digitalWrite(LED, LOW); 
  digitalWrite(BUZZER, LOW); 
}
void loop() {
  
  if (Serial.available() > 0) { 
    
    String a = Serial.readString(); 
    Serial.print(a);
    Serial.println(":");
   for(int j = 0;j < a.length();j++){ 
    char Char_to_morse = tolower(a[j]);
    Serial.print(Char_to_morse);
    for (int i = 0; i < Size; i++) {
      
      if (Char_to_morse == MorseCodeForCharsAndDigits[i][0])
      { 
        Serial.print(" ---   "); 
        
        for (int j = 1; j < 7; j++) 
        { 
          
          if (MorseCodeForCharsAndDigits[i][j] == '.') 
          { 
            digitalWrite(LED, HIGH); 
            digitalWrite(BUZZER, HIGH);
            delay(100); 
            digitalWrite(LED, LOW); 
            digitalWrite(BUZZER, LOW);
            delay(100); 
            Serial.print(" * ");
          }
          else if (MorseCodeForCharsAndDigits[i][j] == '-') 
          { 
             
            digitalWrite(LED, HIGH);  
            digitalWrite(BUZZER, HIGH);
            delay(300); 
            digitalWrite(LED, LOW);
            digitalWrite(BUZZER, LOW);
            delay(100); 
            Serial.print(" - ");
          }
         
          else
          { 
            delay(200);   // koniec wysyłania sygnalu jednego znaku
            Serial.println("  ");
            break; 
          }
        }        
        break;
      } 
      if(Char_to_morse == ' ')
      {
           Serial.println("");
           delay(600); // Koniec wyrazu
           break;
      }
    }
   }    
  }
}

