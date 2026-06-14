; ==========================================
; INTERRUPÇÃO: TIMER0_OVF (Multiplexação)
; ==========================================
TIMER0_OVF:
    push r16
    in r16, SREG
    push r16
    push r17
    push r30
    push r31

    ldi r17, 0

    in r16, PORTB
    ori r16, 0x07
    out PORTB, r16

    ldi ZL, low(TABELA_7SEG * 2)
    ldi ZH, high(TABELA_7SEG * 2)

    cpi R19, 0
    breq MUX_D1
    cpi R19, 1
    breq MUX_D2

MUX_D3:
    add ZL, R22
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB
    andi r16, ~(1<<PB2)
    out PORTB, r16
    ldi R19, 0
    rjmp MUX_SAIR

MUX_D1:
    add ZL, R20
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB
    andi r16, ~(1<<PB0)
    out PORTB, r16
    ldi R19, 1
    rjmp MUX_SAIR

MUX_D2:
    add ZL, R21
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB
    andi r16, ~(1<<PB1)
    out PORTB, r16
    ldi R19, 2

MUX_SAIR:
    pop r31
    pop r30
    pop r17
    pop r16
    out SREG, r16
    pop r16
    reti