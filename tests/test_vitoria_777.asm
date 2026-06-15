; ======================================================================
; TESTE: Vitória 777
;
; Condição testada : TCNT0 < 13  →  branch DEU_VITORIA_777
; Resultado esperado: DIGIT_* = 7 nos três displays, LED piscando
;
; Como funciona:
;   TCNT0 é injetado com o valor 0 antes de CALCULA_RESULTADO.
;   Com prescaler /64 a 16 MHz, o timer avança ~1 ciclo por 4 µs.
;   As poucas instruções entre a escrita e o "IN AUX_2, TCNT0" adicionam
;   no máximo 5 ao valor — ainda bem abaixo do limiar de 13.
;
; Verificação visual no SimulIDE:
;   [ ] Os três displays exibem "7"
;   [ ] O LED fica piscando (LED_STATE = 2)
; ======================================================================

.include "m328Pdef.inc"

.def AUX               = R16
.def AUX_2             = R17
.def BUTTON_PRESSED_FLAG = R18
.def SELECTED_DISPLAY  = R19
.def DIGIT_UNIT        = R20
.def DIGIT_TENS        = R21
.def DIGIT_HUNDREDS    = R22
.def ANIMATION_COUNTER = R23
.def LED_STATE         = R24
.def RESULT_UNIT       = R26
.def RESULT_TENS       = R27
.def RESULT_HUNDREDS   = R28
.def DELAY_AUX         = R29
.def ENTROPIA_UNIT     = R10
.def ENTROPIA_TENS     = R11
.def ENTROPIA_HUNDREDS = R12

.org 0x0000
    RJMP TEST_SETUP
.org 0x0002
    RJMP BOTAO_INT
.org 0x0020
    RJMP TIMER0_OVF

TEST_SETUP:
    LDI AUX, high(RAMEND)
    OUT SPH, AUX
    LDI AUX, low(RAMEND)
    OUT SPL, AUX

    LDI AUX, 0xFB
    OUT DDRD, AUX
    LDI AUX, 0x04
    OUT PORTD, AUX

    LDI AUX, 0x0F
    OUT DDRB, AUX
    LDI AUX, 0x07
    OUT PORTB, AUX

    LDI AUX, (1<<CS01) | (1<<CS00)
    OUT TCCR0B, AUX
    LDI AUX, (1<<TOIE0)
    STS TIMSK0, AUX

    LDI AUX, (1<<CS10)
    STS TCCR1B, AUX

    ; INT0 (Botão)
    LDI AUX, (1<<ISC01) | (1<<ISC00)
    STS EICRA, AUX
    LDI AUX, (1<<INT0)
    OUT EIMSK, AUX

    LDI BUTTON_PRESSED_FLAG, 0
    LDI SELECTED_DISPLAY, 0
    LDI DIGIT_UNIT, 0
    LDI DIGIT_TENS, 0
    LDI DIGIT_HUNDREDS, 0
    LDI LED_STATE, 0

    SEI

    LDI DELAY_AUX, 250
    RCALL DELAY_MS
    LDI DELAY_AUX, 250
    RCALL DELAY_MS

    LDI AUX, (1<<INTF0)
    OUT EIFR, AUX
    LDI BUTTON_PRESSED_FLAG, 0

    ; Injeta TCNT0 = 0 → garante que CALCULA_RESULTADO leia valor < 13
    LDI AUX, 0
    OUT TCNT0, AUX

    RJMP CALCULA_RESULTADO

MAIN_LOOP:
    CPI BUTTON_PRESSED_FLAG, 1
    BRNE CHECK_LED
    RJMP CALCULA_RESULTADO
CHECK_LED:
    CPI LED_STATE, 2
    BRNE MAIN_LOOP
    LDI DELAY_AUX, 100
    RCALL DELAY_MS
    IN AUX, PORTB
    LDI AUX_2, (1<<PB3)
    EOR AUX, AUX_2
    OUT PORTB, AUX
    RJMP MAIN_LOOP

.include "tabela.asm"
.include "delay.asm"
.include "mux.asm"
.include "botao.asm"
.include "sorteio.asm"
