/*
 *   AUTOR: MICHAŁ BRONIKOWSKI
 *   WYKORZYSTANO FRAGMENTY PRZYKLADOWEGO KODU DOT KOMUNIKACJI WEJSCIA I WYJSCIA AUTORSTWA PANA MARKA MATERZOKA
 *
 * */
#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <math.h>
#include <stdlib.h> 
#define BAUD 9600
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)

FILE uart_file;


void initTIMER() {
    TCCR1B |= 1<<CS10;
}

// transmisja jednego znaku
int uart_transmit(char data, FILE *stream) {
    // czekaj aż transmiter gotowy
    while(!(UCSR0A & _BV(UDRE0)));
    UDR0 = data;
    return 0;
}

// odczyt jednego znaku
int uart_receive(FILE *stream) {
    // czekaj aż znak dostêpny
    while (!(UCSR0A & _BV(RXC0)));
    return UDR0;
}

// inicjalizacja UART
void uart_init() {
    // ustaw baudrate
    UBRR0 = UBRR_VALUE;
    // wlącz odbiornik i nadajnika
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);
    // ustaw format 8n1
    UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);

    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;
}


void show_results(char * name) {
    uint16_t time = TCNT1;
    printf("%s time in %"PRIu16" cycles\n\r", name, time);
    TCNT1 = 0;
}

uint8_t t_uint8() {
    uint8_t v = rand()%10;

    TCNT1 = 0;
        v+=v;
    show_results("uint8 addition");
        v*=v;
    show_results("uint8 multiplication");
        v/=v;
    show_results("uint8 division");
        v=v-4%v;
    show_results("uint8 modulo");
    return v;

}

uint16_t t_uint16() {
    uint16_t v = rand()%20;

    TCNT1 = 0;
        v+=v;
    show_results("uint16 addition");
        v*=v;
    show_results("uint16 multiplication");
        v/=v;
    show_results("uint16 division");
        v=v-4%v;
    show_results("uint16 modulo");
    return v;
}

uint32_t t_uint32() {
    volatile uint32_t v = rand()%100;

    TCNT1 = 0;
        v+=v;
    show_results("uint32 addition");
        v*=v;
    show_results("uint32 multiplication");
        v/=v;
    show_results("uint32 division");
        v=v-4%v;
    show_results("uint32 modulo");
    return v;
}

float  t_float() {
    float v = rand()%20+10*0.123;

    TCNT1 = 0;
        v+=v;
    show_results("float addition");
        v*=v;
    show_results("float multiplication");
        v = pow(v,5);
    show_results("float exponentation");
    return v;
}

double t_double() {
    double v = rand()%50 + rand()%2 * 0.789;

    TCNT1 = 0;
        v+=v;
    show_results("double addition");
        v*=v;
    show_results("double multiplication");
        v = pow(v,5);
    show_results("double exponentation");
    return v;
}

int main(void) {
    srand (rand()%20);
    initTIMER();
    uart_init();
    int res;
        res+=t_uint8();
        res+=t_uint16();
        res+=t_uint32();
        res+=t_float();
        res+=t_double();

    return res;
}

