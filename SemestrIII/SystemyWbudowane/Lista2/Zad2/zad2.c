#include <avr/io.h>
#include <util/delay.h>
#define  F_CPU = 8000000L
#define LED       0b00000010
#define IR_LED    0b00000100
#define DETECTOR  0b00000100
#define LED_PORT PORTB
#define LED_DDR  DDRB
#define DETECTOR_PIN  PIND
#define DETECTOR_PORT PORTD
#define _BV(bit) (1<<(bit))
void initTimer() {
	TCCR1A |= _BV(COM1B1);
    TCCR1B |= _BV(WGM13) | _BV(CS11);
}


int main() {
	initTimer();
	LED_DDR |= IR_LED | LED;
	DETECTOR_PORT |= DETECTOR;
	LED_PORT |= LED;
    ICR1 = 26.3;
    OCR1B = 15; //pin 10

	while(1) {
		if((DETECTOR_PIN & DETECTOR))
		LED_PORT |= LED;
		else
		LED_PORT &= ~LED;
		_delay_ms(50);

	}
}
