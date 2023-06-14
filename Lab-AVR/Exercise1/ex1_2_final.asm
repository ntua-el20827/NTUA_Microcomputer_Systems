.include "m328PBdef.inc"

reset:
    ldi r24, low(RAMEND)
    out SPL, r24
    ldi r24, high(RAMEND)
    out SPH, r24
    
init:    
    ser r23
    out DDRD, r23	;PORTD as output
    
    ldi r23, 0x08	;LED initialized at LSB
    
    rjmp shift_left

    
shift_right:
    out PORTD, r23	;output 
    ldi r24, low(1000)
    ldi r25, high(1000)
    rcall wait_msec	;wait 1000ms  
    lsr r23		;shift right
    cpi r23, 0x01	;check if the LED is at LSB   
    breq change_r	;if not, continue shifting right
    brne shift_right

change_r:
    out PORTD, r23	;output 
    ldi r24, low(2000)
    ldi r25, high(2000)
    rcall wait_msec	;wait extra 1000ms   
    ldi r23, 0x02	;new led position
    rjmp shift_left	;continue
    
shift_left:
    out PORTD, r23	;output 
    ldi r24, low(1000)
    ldi r25, high(1000)
    rcall wait_msec	;wait 1000ms   
    lsl r23		;shift left
    cpi r23, 0x80	;check if the LED is at MSB
    breq change_l
    brne shift_left	;if not, continue shifting left

change_l:	
    out PORTD, r23	;output 
    ldi r24, low(2000)
    ldi r25, high(2000)
    rcall wait_msec	;wait extra 1000ms
    ldi r23, 0x40	;new led position
    rjmp shift_right	;continue
   
wait_msec:
    push r24
    push r25
    ldi r24 , low(998)
    ldi r25 , high(998) 
    rcall wait_usec 
    pop r25 
    pop r24 
    sbiw r24 , 1
    brne wait_msec 
    ret 
wait_usec:
    sbiw r24 ,1 
    nop 
    nop 
    nop 
    nop		     ;4 cycles
    brne wait_usec 
    ret 
	    