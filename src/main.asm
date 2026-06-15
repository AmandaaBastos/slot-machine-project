; ======================================================================
; PROJETO FINAL MATA49 - CAÇA-NÍQUEIS
; Sorteio Dinâmico por Entropia de Hardware (TCNT0)
; 20% de Vitória | Combinações de 000 a 999
; ======================================================================

.include "m328Pdef.inc"

; ==========================================
; VETORES DE INTERRUPÇÃO
; ==========================================
.org 0x0000
    RJMP RESET
.org 0x0002
    RJMP BOTAO_INT
.org 0x0020
    RJMP TIMER0_OVF

; ==========================================
; CONFIGURAÇÃO INICIAL (SETUP)
; ==========================================
RESET:
    LDI r16, high(RAMEND)
    OUT SPH, r16
    LDI r16, low(RAMEND)
    OUT SPL, r16

    ; Portas e Pull-up
    LDI r16, 0xFB
    OUT DDRD, r16
    LDI r16, 0x04
    OUT PORTD, r16

    ; Transistores e LED
    LDI r16, 0x0F
    OUT DDRB, r16
    LDI r16, 0x07
    OUT PORTB, r16

    ; Timer0 (Multiplexação e Entropia)
    LDI r16, (1<<CS01) | (1<<CS00)
    OUT TCCR0B, r16
    LDI r16, (1<<TOIE0)
    STS TIMSK0, r16

    ; Variáveis
    LDI R18, 0
    LDI R19, 0
    LDI R20, 0
    LDI R21, 0
    LDI R22, 0
    LDI R24, 0    ; flag do led    0 = desliga, 1=liga, 2=pisca

    ; INT0 (Botão)
    LDI r16, (1<<ISC01) | (1<<ISC00)
    STS EICRA, r16
    LDI r16, (1<<INT0)
    OUT EIMSK, r16

    SEI

    LDI R29, 250
    RCALL DELAY_MS
    LDI R29, 250
    RCALL DELAY_MS

    LDI r16, (1<<INTF0)
    OUT EIFR, r16

; ==========================================
; LOOP PRINCIPAL (AGUARDANDO BOTÃO)
; ==========================================
MAIN_LOOP:
    CPI R18, 1
    BRNE CHECK_LED
    RJMP CALCULA_RESULTADO
CHECK_LED:
    CPI R24, 2
    BRNE MAIN_LOOP

    ; lógica do led pisca
    LDI R29, 100
    RCALL DELAY_MS
    IN r16, PORTB
    LDI r17, (1<<PB3)
    EOR r16, r17
    OUT PORTB, r16

    RJMP MAIN_LOOP

; ==========================================
; MÓDULOS
; ==========================================
.include "tabela.asm"
.include "delay.asm"
.include "mux.asm"
.include "botao.asm"
.include "sorteio.asm"
