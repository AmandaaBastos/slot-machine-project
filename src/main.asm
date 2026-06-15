; ======================================================================
; PROJETO FINAL MATA49 - CAÇA-NÍQUEIS
; Sorteio Dinâmico por Entropia de Hardware (TCNT0)
; 20% de Vitória | Combinações de 000 a 999
; ======================================================================

.include "m328Pdef.inc"

; ==========================================
; INICIALIZAÇÃO DE VARIÁVEIS
; ==========================================
.equ LED_OUTPUT = PB3

.def AUX = R16
.def AUX_2 = R17
.def BUTTON_PRESSED_FLAG = R18
.def SELECTED_DISPLAY = R19
.def DIGIT_UNIT = R20
.def DIGIT_TENS = R21
.def DIGIT_HUNDREDS = R22
.def ANIMATION_COUNTER = R23
.def LED_STATE = R24
.def RESULT_UNIT = R26
.def RESULT_TENS = R27
.def RESULT_HUNDREDS = R28
.def DELAY_AUX = R29
.def ENTROPIA_UNIT = R10
.def ENTROPIA_TENS = R11
.def ENTROPIA_HUNDREDS = R12
.def AUX = R16
.def AUX_2 = R17
.def BUTTON_PRESSED_FLAG = R18
.def SELECTED_DISPLAY = R19
.def DIGIT_UNIT = R20
.def DIGIT_TENS = R21
.def DIGIT_HUNDREDS = R22
.def ANIMATION_COUNTER = R23
.def LED_STATE = R24
.def RESULT_UNIT = R26
.def RESULT_TENS = R27
.def RESULT_HUNDREDS = R28
.def DELAY_AUX = R29
.def ENTROPIA_UNIT = R10
.def ENTROPIA_TENS = R11
.def ENTROPIA_HUNDREDS = R12

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
    ; Timer1 (Entropia Adicional)
    LDI AUX, (1<<CS10)
    STS TCCR1B, AUX
    
    ; INT0 (Botão)
    LDI AUX, (1<<ISC01) | (1<<ISC00)
    STS EICRA, AUX
    LDI AUX, (1<<INT0)
    OUT EIMSK, AUX

    ; Variáveis
    LDI SELECTED_DISPLAY, 0
    LDI DIGIT_UNIT, 10
    LDI DIGIT_TENS, 10
    LDI DIGIT_HUNDREDS, 10
    LDI LED_STATE, 0    ; flag do led    0 = desliga, 1=liga, 2=pisca


    SEI

    LDI DELAY_AUX, 250
    RCALL DELAY_MS
    LDI DELAY_AUX, 250
    RCALL DELAY_MS
    LDI BUTTON_PRESSED_FLAG, 0

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
    CPI LED_STATE, 2
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
