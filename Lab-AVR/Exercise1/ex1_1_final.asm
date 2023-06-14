.include "m328PBdef.inc"

.DEF temp = r16
.DEF A = r17
.DEF B= r18
.DEF C = r19
.DEF D = r20
.DEF F0 = r21
.DEF F1 = r22

reset:
    ldi r26,low(RAMEND)		;Initialize stack pointer on top of sram, loads lowbyte RAMEND address on r26
    out SPL,r26			;sets the low byte of the Stack Pointer (SP) 
    ldi r26,high(RAMEND)
    out SPH,r26

start:
    clr temp			
    out DDRB,temp		; portB as input
    ser temp
    out PORTB,temp		;pull-up port B
    out DDRC,temp		;port C c as output

main:
    clr F0 ; 			; clear F0
    clr F1 ; 			; clear F0
    in temp, PINB		; ανάγνωση ακροδεκτών PORTA
    mov A, temp			; το Α στο LSB του καταχωρητή Α
    lsr temp
    mov B, temp			; το B στο LSB του καταχωρητή B
    lsr temp
    mov C, temp			; το C στο LSB του καταχωρητή C
    lsr temp
    mov D, temp			; το D στο LSB του καταχωρητή D
    mov temp,A			; προσωρινή αποθήκευση του A για αργοτερα
    mov F0,B
    com F0			; συμπληρωμα B
    and F0,D			; LSB(F0) = B'D
    and A,B			; lSB(A) = AB
    or F0,A 			; LSB(f0)=(AB + B'D)

    
    com D			; D'
    or D,B 			; lSB(D) = B+D'
    com temp			; συμπληρωμα A
    com C			; συμπληρωμα C
    or temp,C			; LSB(temp) = a' + c', να δουμε μηπως (αc)' γιατι γλιτωνω εντολη
			 	; αφου temp = a, and temp,c (ac) comp temp (ac)' = a' + c'
    			 	;  ???? temp = a, and temp,c = (ac), comp temp (ac)' = a' + c'
    
    and D, temp			; LSB(D) = (A'+C')(B+D')
    lsl D			; 2o LSB(D) = (A'+C')(B+D')
    mov F1, D			; 2o LSB(F1) = (A'+C')(B+D')

    andi F0, 0x01		;Preserve LSB of Fo, clear other bits
    andi F1, 0x02		;Preserve second LSB of F1, clear other bits
    or F0,F1			;Fo: Fo in lsb, F1 in second LSB: 000000F1F0
    out PORTC,F0		;Output in

    rjmp main 

