; ==========================================
; INTERRUPÇÃO: TIMER0_OVF (Multiplexação)
; ==========================================
TIMER0_OVF:
    PUSH r16
    IN r16, SREG
    PUSH r16
    PUSH r17
    PUSH r30
    PUSH r31

    LDI r17, 0

    IN r16, PORTB
    ORI r16, 0x07
    OUT PORTB, r16

    LDI ZL, low(TABELA_7SEG * 2)
    LDI ZH, high(TABELA_7SEG * 2)

    CPI R19, 0
    BREQ MUX_D1
    CPI R19, 1
    BREQ MUX_D2

MUX_D3:
    ADD ZL, R22
    ADC ZH, r17
    LPM r16, Z
    OUT PORTD, r16
    IN r16, PORTB
    ANDI r16, ~(1<<PB2)
    OUT PORTB, r16
    LDI R19, 0
    RJMP MUX_SAIR

MUX_D1:
    ADD ZL, R20
    ADC ZH, r17
    LPM r16, Z
    OUT PORTD, r16
    IN r16, PORTB
    ANDI r16, ~(1<<PB0)
    OUT PORTB, r16
    LDI R19, 1
    RJMP MUX_SAIR

MUX_D2:
    ADD ZL, R21
    ADC ZH, r17
    LPM r16, Z
    OUT PORTD, r16
    IN r16, PORTB
    ANDI r16, ~(1<<PB1)
    OUT PORTB, r16
    LDI R19, 2

MUX_SAIR:
    POP r31
    POP r30
    POP r17
    POP r16
    OUT SREG, r16
    POP r16
    RETI