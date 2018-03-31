/*
 * Musicv3.c
 *
 * Created: 2017-11-09 21:55:45
 * Author : Radoslaw Madzia
 */ 

#define F_CPU 4000000UL
#define  _BV(bit) (1<<(bit))
#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "Notes.h"



const int16_t axel_f[] PROGMEM = {NOTE_FS4, 2, REST, 2, NOTE_A4, 3, NOTE_FS4, 2,NOTE_FS4, 1,NOTE_B4, 2,NOTE_FS4, 2,NOTE_E4, 2,NOTE_FS4, 2,REST, 2,NOTE_CS5, 3,NOTE_FS4, 2,
							NOTE_FS4, 1, NOTE_D5, 2 ,NOTE_CS5, 2,NOTE_A4, 2,NOTE_FS4, 2,NOTE_CS5, 2,NOTE_FS5, 2,NOTE_FS4, 1,NOTE_E4, 2,NOTE_E4, 1,NOTE_CS4, 2,NOTE_GS4, 2,
							NOTE_FS4, 6,REST, 8 , NOTE_A4, 1, NOTE_A4, 1, REST , 12, MUSIC_END} ;

const int16_t octave[] PROGMEM  = { NOTE_C4, 2 , NOTE_CS4, 2 , NOTE_D4, 2, NOTE_DS4, 2, NOTE_E4, 2, NOTE_FS4,2,  MUSIC_END };

const int underworld_melody[] PROGMEM =  {
	NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
	NOTE_AS3, NOTE_AS4, REST,
	REST,
	NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
	NOTE_AS3, NOTE_AS4, REST,
	REST,
	NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
	NOTE_DS3, NOTE_DS4, REST,
	REST,
	NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
	NOTE_DS3, NOTE_DS4, REST,
	REST, NOTE_DS4, NOTE_CS4, NOTE_D4,
	NOTE_CS4, NOTE_DS4,
	NOTE_DS4, NOTE_GS3,
	NOTE_G3, NOTE_CS4,
	NOTE_C4, NOTE_FS4, NOTE_F4, NOTE_E3, NOTE_AS4, NOTE_A4,
	NOTE_GS4, NOTE_DS4, NOTE_B3,
	NOTE_AS3, NOTE_A3, NOTE_GS3,
	MUSIC_END};
const int underworld_tempo[] PROGMEM= {
	12, 12, 12, 12,
	12, 12, 6,
	3,
	12, 12, 12, 12,
	12, 12, 6,
	3,
	12, 12, 12, 12,
	12, 12, 6,
	3,
	12, 12, 12, 12,
	12, 12, 6,
	6, 18, 18, 18,
	6, 6,
	6, 6,
	6, 6,
	18, 18, 18, 18, 18, 18,
	10, 10, 10,
	10, 10, 10,
	
};

void initTimer() {
	TCCR0A |= (1 << WGM01); // CCT
	TCCR0A |= (1 << COM0A0);
	TCCR0B |= (1 << CS02); //256
}

void playNote(uint8_t waveLength, uint8_t duration) {
	OCR0A = waveLength;
	DDRD =0x40;
	for(; duration>0; duration--)
	_delay_ms(89);
	DDRD = 0x00;

}

int main(void) {
	initTimer();
	while (1) {
		
		for(int i = 0; (pgm_read_word(&(octave[i])))!=MUSIC_END ; i+=2)
			playNote(pgm_read_word(&(octave[i])),pgm_read_word(&(octave[i+1]))<<2);
		_delay_ms(1000);

		for(int i = 0; (pgm_read_word(&(axel_f[i])))!=MUSIC_END ; i+=2)
			playNote(pgm_read_word(&(axel_f[i])) , pgm_read_word(&(axel_f[i+1]))*6);
		for(int i = 0; (pgm_read_word(&(axel_f[i])))!=MUSIC_END ; i+=2)
			playNote(pgm_read_word(&(axel_f[i])) , pgm_read_word(&(axel_f[i+1]))*6);
		_delay_ms(1000);	
		for(int i = 0; (pgm_read_word(&(underworld_melody[i])))!=MUSIC_END ; i++)
			playNote(pgm_read_word(&(underworld_melody[i])),pgm_read_word(&(underworld_tempo[i]))>>1);
		_delay_ms(1000);
	}
}
