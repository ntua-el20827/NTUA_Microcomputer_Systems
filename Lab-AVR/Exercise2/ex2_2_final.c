#define F_CPU 16000000UL // Define the CPU frequency for delay functions 
#include<avr/io.h> // Include AVR I/O library
#include<avr/interrupt.h> // Include AVR interrupt library
#include<util/delay.h> // Include delay library


volatile int count=0; // Declare a volatile variable to count the time


ISR (INT1_vect) // Interrupt Service Routine for external interrupt INT1
{
  PORTB = 0xFF;
  _delay_ms(500);
  PORTB = 0x01;
  count=3500;
}


int main ()
{
    EICRA=(1 << ISC11) | (1 << ISC10); // Set INT1 to trigger on rising edge
    EIMSK=(1 << INT1); // Enable external interrupt INT1
    sei(); // Enable global interrupts    or after
    
    //DDRD &= ~(1 << PD3);  //PORTD input, pull-up resistor
    //PORTD |= (1 << PD3);
    DDRD = 0x00;
    DDRB=0xFF;  //PORTB output
    PORTB = 0x00;
    //flag=0;
    //count=0;
    
    while(1) {
        while(count>0)
        {
            _delay_ms(1);
            PORTB = 0x01;
            count=count-1;
        }
        PORTB = 0x00; // Turn off all LEDs on PORTB
    }
}