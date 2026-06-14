; ======================================================================
; PROJETO FINAL MATA49 - CAÇA-NÍQUEIS
; Sorteio Dinâmico por Entropia de Hardware (TCNT0)
; 20% de Vitória | Combinações de 000 a 999
; ======================================================================

.nolist
.include "m328Pdef.inc"
.list

; ==========================================
; VETORES DE INTERRUPÇÃO
; ==========================================
.org 0x0000
    rjmp RESET
.org 0x0002
    rjmp BOTAO_INT
.org 0x0020
    rjmp TIMER0_OVF

; ==========================================
; CONFIGURAÇÃO INICIAL (SETUP)
; ==========================================
RESET:
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    ; Portas e Pull-up
    ldi r16, 0xFB
    out DDRD, r16
    ldi r16, 0x04
    out PORTD, r16

    ; Transistores e LED
    ldi r16, 0x0F
    out DDRB, r16
    ldi r16, 0x07
    out PORTB, r16

    ; Timer0 (Multiplexação e Entropia)
    ldi r16, (1<<CS01) | (1<<CS00)
    out TCCR0B, r16
    ldi r16, (1<<TOIE0)
    sts TIMSK0, r16

    ; Variáveis
    ldi R18, 0
    ldi R19, 0
    ldi R20, 0
    ldi R21, 0
    ldi R22, 0

    ; INT0 (Botão)
    ldi r16, (1<<ISC01)
    sts EICRA, r16
    ldi r16, (1<<INT0)
    out EIMSK, r16

    sei

    ldi R29, 250
    rcall DELAY_MS
    ldi R29, 250
    rcall DELAY_MS

    ldi r16, (1<<INTF0)
    out EIFR, r16

; ==========================================
; LOOP PRINCIPAL (AGUARDANDO BOTÃO)
; ==========================================
MAIN_LOOP:
    cpi R18, 1
    brne MAIN_LOOP
    rjmp CALCULA_RESULTADO

; ==========================================
; MÓDULOS
; ==========================================
.include "tabela.asm"
.include "delay.asm"
.include "mux.asm"
.include "botao.asm"
.include "sorteio.asm"
