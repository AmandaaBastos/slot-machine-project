; ======================================================================
; PROJETO FINAL MATA49 - CAÇA-NÍQUEIS
; Sorteio Dinâmico por Entropia de Hardware (TCNT0)
; 20% de Vitória | Combinações de 000 a 999
; ======================================================================

.include "m328Pdef.inc"

; ==========================================
; INICIALIZAÇÃO DE VARIÁVEIS
; ==========================================
.EQU LED_OUTPUT = PB3

.DEF AUX = R16
.DEF AUX_2 = R17
.DEF BUTTON_PRESSED_FLAG = R18
.DEF SELECTED_DISPLAY = R19
.DEF DIGIT_UNIT = R20
.DEF DIGIT_TENS = R21
.DEF DIGIT_HUNDREDS = R22
.DEF ANIMATION_COUNTER = R23
.DEF LED_FLAG = R24
.DEF RESULT_UNIT = R26
.DEF RESULT_TENS = R27
.DEF RESULT_HUNDREDS = R28
.DEF DELAY_AUX = R29

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
    LDI AUX, high(RAMEND)
    OUT SPH, AUX
    LDI AUX, low(RAMEND)
    OUT SPL, AUX

    ; Portas e Pull-up
    LDI AUX, 0xFB
    OUT DDRD, AUX
    LDI AUX, 0x04
    OUT PORTD, AUX

    ; Transistores e LED
    LDI AUX, 0x0F
    OUT DDRB, AUX
    LDI AUX, 0x07
    OUT PORTB, AUX

    ; Timer0 (Multiplexação e Entropia)
    LDI AUX, (1<<CS01) | (1<<CS00)
    OUT TCCR0B, AUX
    LDI AUX, (1<<TOIE0)
    STS TIMSK0, AUX

    ; Variáveis
    LDI BUTTON_PRESSED_FLAG, 0
    LDI SELECTED_DISPLAY, 0
    LDI DIGIT_UNIT, 0
    LDI DIGIT_TENS, 0
    LDI DIGIT_HUNDREDS, 0
    LDI LED_FLAG, 0    ; flag do led    0 = desliga, 1=liga, 2=pisca

    ; INT0 (Botão)
    LDI AUX, (1<<ISC01) | (1<<ISC00)
    STS EICRA, AUX
    LDI AUX, (1<<INT0)
    OUT EIMSK, AUX

    SEI

    LDI DELAY_AUX, 250
    RCALL DELAY_MS
    LDI DELAY_AUX, 250
    RCALL DELAY_MS

    LDI AUX, (1<<INTF0)
    OUT EIFR, AUX

; ==========================================
; LOOP PRINCIPAL (AGUARDANDO BOTÃO)
; ==========================================
MAIN_LOOP:
    CPI BUTTON_PRESSED_FLAG, 1
    BRNE CHECK_LED
    RJMP CALCULA_RESULTADO
CHECK_LED:
    CPI LED_FLAG, 2
    BRNE MAIN_LOOP

    ; lógica do led pisca
    LDI DELAY_AUX, 100
    RCALL DELAY_MS
    IN AUX, PORTB
    LDI AUX_2, (1 << LED_OUTPUT)
    EOR AUX, AUX_2
    OUT PORTB, AUX

    RJMP MAIN_LOOP

; ==========================================
; MÓDULOS
; ==========================================
.include "tabela.asm"
.include "delay.asm"
.include "mux.asm"
.include "botao.asm"
.include "sorteio.asm"
