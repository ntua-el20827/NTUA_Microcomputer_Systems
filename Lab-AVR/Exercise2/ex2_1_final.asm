.include "m328PBdef.inc"
.cseg
.org 0x0
rjmp reset
.org 0x4
rjmp ISR1				    ;routina eksipiretisis

reset:
    ldi r16, LOW(RAMEND)    
    out SPL, r16
    ldi r16, HIGH(RAMEND)   
    out SPH, r16
    
    ldi r16, (1 << ISC11) | (1 << ISC10)    ;interrupt triggered on upcoming edge of INT1 
    sts EICRA, r16

    ldi r16, (1 << INT1)		    ;enables the INT1 external interrupt.
    out EIMSK, r16
    
    sei					    ;enables global interrupts by setting the global interrupt flag.(sreg)
    clr r16   
    out DDRD, r16
    ser r16   
    out DDRC, r16
    
    

help1:
    clr r17   
    ;out PORTC, r17
    
main:
    out PORTC, r17
    rjmp main
    
ISR1:
    in r16, PIND   
    sbrs r16, 7				;if PORTD7 = 1 THEN skip the next one
    reti				;else if PORTD7 = 0, return from the interrupt, resume main program
    
    cpi r17, 31   
    breq zero
    
    inc r17  
    ;out PORTC, r17
    reti
    
zero:
    ldi r17, 0x00   
    reti


