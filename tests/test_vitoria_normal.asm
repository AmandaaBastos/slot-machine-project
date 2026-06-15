; ======================================================================
; TESTE: Vitória Normal
;
; Condição testada : 13 ≤ TCNT0 < 51  →  branch DEU_VITORIA_NORMAL
; Resultado esperado: DIGIT_* = mesmo dígito nos três displays (≠ 7),
;                     LED aceso fixo
;
; Como funciona:
;   TCNT0 é injetado com 14. Mesmo somando ~5 ciclos de jitter até o
;   "IN AUX_2, TCNT0", o valor fica em [14, 19] — dentro da janela
;   [13, 50] que aciona DEU_VITORIA_NORMAL.
;
;   O dígito exibido = (14..19) % 10 = 4..9, e se vier 7 o código
;   substitui por 8 automaticamente.
;
; Verificação visual no SimulIDE:
;   [ ] Os três displays mostram o mesmo dígito (4–9, nunca 7)
;   [ ] O LED fica aceso fixo (LED_STATE = 1)
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

    ; Injeta TCNT0 = 14 → valor lido em CALCULA_RESULTADO fica em [14,19]
    ; Janela de vitória normal: [13, 50]
    LDI AUX, 14
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
