#include <avr/io.h>
#include "hello.h"
#include <util/delay.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#define int8 uint8_t
#define SPEAKER 0b0100000
#define _BV(x)(1<<x)

int iter = 0;

void initTimer() {
    TCCR0A |= _BV(COM0A1);
    TCCR0A |=_BV(WGM01) | _BV(WGM00);
    TCCR0B |= _BV(CS00);

    cli();
    TCCR1B |= _BV(WGM12);
    TCCR1B |= _BV(CS10);
    OCR1A = 2000;
    TIMSK1 |= _BV(OCIE1A);
    sei();
}

ISR(TIMER1_COMPA_vect) {
    for (int i=0;i<sounddata_length;++i)
    OCR0A = pgm_read_byte(&(sounddata_data[i]));
}


int main(void) {
    initTimer();

    DDRD |= SPEAKER | 0x10;

    while (1) {
    }
}
