; ==========================================
; ETAPA 1: LÓGICA DE SORTEIO (5% 777 + 15% NORMAL + 80% DERROTA)
; ==========================================
CALCULA_RESULTADO:
    IN AUX, PORTB
    ANDI AUX, ~(1<<PB3)
    OUT PORTB, AUX
    LDI LED_STATE, 0   ; Reset do led p/ prox rodada

    ; 1. LÊ A ENTROPIA DO HARDWARE NO MOMENTO EXATO DO CLIQUE
    IN AUX_2, TCNT0       ; AUX_2 = Valor Aleatório (0 a 255)

    ; 2. 5% para vitória 777
    CPI AUX_2, 13
    BRLO DEU_VITORIA_777

    ; 3. 15% para vitória normal
    CPI AUX_2, 51
    BRLO DEU_VITORIA_NORMAL

    ; 4. resto da porcentagem derrota
    RJMP DEU_DERROTA

DEU_VITORIA_777:
    LDI AUX, 7
    MOV RESULT_UNIT, AUX
    MOV RESULT_TENS, AUX
    MOV RESULT_HUNDREDS, AUX
    LDI LED_STATE, 2   ; ativa o modo blink
    RJMP INICIA_ANIMACAO

DEU_VITORIA_NORMAL:
    ; Pega um número aleatório (0 a 9)
    MOV AUX, AUX_2
    RCALL MODULO_10

    ; Impede que vitória normal também seja 7
    CPI AUX, 7
    BRNE APLICA_VITORIA_NORMAL
    LDI AUX, 8          ; Se der 7, transforma em 8

APLICA_VITORIA_NORMAL:
    MOV RESULT_UNIT, AUX
    MOV RESULT_TENS, AUX
    MOV RESULT_HUNDREDS, AUX
    LDI LED_STATE, 1   ; led ligado fixo
    RJMP INICIA_ANIMACAO

DEU_DERROTA:
    LDS ENTROPIA_UNIT, TCNT1L
    LDS ENTROPIA_TENS, TCNT1H
    LDS ENTROPIA_HUNDREDS, TCNT1L

    ; Gera o Dígito 1
    MOV AUX, ENTROPIA_UNIT
    RCALL MODULO_10
    MOV RESULT_UNIT, AUX

    ; Gera o Dígito 2
    MOV AUX, ENTROPIA_TENS
    RCALL MODULO_10
    MOV RESULT_TENS, AUX

    ; Gera o Dígito 3
    MOV AUX, ENTROPIA_HUNDREDS
    RCALL MODULO_10
    MOV RESULT_HUNDREDS, AUX

    ; Impede que haja uma falsa vitória na derrota
    CP RESULT_UNIT, RESULT_TENS
    BRNE INICIA_ANIMACAO
    CP RESULT_TENS, RESULT_HUNDREDS
    BRNE INICIA_ANIMACAO

    ; Se os 3 ficarem iguais por acidente, altera o último
    INC RESULT_HUNDREDS
    MOV AUX, RESULT_HUNDREDS
    RCALL MODULO_10
    MOV RESULT_HUNDREDS, AUX
    RJMP INICIA_ANIMACAO

; ==========================================
; ETAPA 2: ANIMAÇÃO EM 3 FASES
; ==========================================
INICIA_ANIMACAO:
    LDI DELAY_AUX, 8

    ; FASE 1
    LDI ANIMATION_COUNTER, 30
FASE_1:
    INC DIGIT_UNIT
    CPI DIGIT_UNIT, 10
    BRNE F1_D2
    LDI DIGIT_UNIT, 0
F1_D2:
    INC DIGIT_TENS
    CPI DIGIT_TENS, 10
    BRNE F1_D3
    LDI DIGIT_TENS, 0
F1_D3:
    INC DIGIT_HUNDREDS
    CPI DIGIT_HUNDREDS, 10
    BRNE F1_DELAY
    LDI DIGIT_HUNDREDS, 0
F1_DELAY:
    RCALL DELAY_MS
    INC DELAY_AUX
    DEC ANIMATION_COUNTER
    BRNE FASE_1

    MOV DIGIT_UNIT, RESULT_UNIT

    ; FASE 2
    LDI ANIMATION_COUNTER, 20
FASE_2:
    INC DIGIT_TENS
    CPI DIGIT_TENS, 10
    BRNE F2_D3
    LDI DIGIT_TENS, 0
F2_D3:
    INC DIGIT_HUNDREDS
    CPI DIGIT_HUNDREDS, 10
    BRNE F2_DELAY
    LDI DIGIT_HUNDREDS, 0
F2_DELAY:
    RCALL DELAY_MS
    INC DELAY_AUX
    INC DELAY_AUX
    DEC ANIMATION_COUNTER
    BRNE FASE_2

    MOV DIGIT_TENS, RESULT_TENS

    ; FASE 3
    LDI ANIMATION_COUNTER, 12
FASE_3:
    INC DIGIT_HUNDREDS
    CPI DIGIT_HUNDREDS, 10
    BRNE F3_DELAY
    LDI DIGIT_HUNDREDS, 0
F3_DELAY:
    RCALL DELAY_MS
    INC DELAY_AUX
    INC DELAY_AUX
    INC DELAY_AUX
    INC DELAY_AUX
    DEC ANIMATION_COUNTER
    BRNE FASE_3

    MOV DIGIT_HUNDREDS, RESULT_HUNDREDS

; ==========================================
; ETAPA 3: FINALIZA E EXIBE
; ==========================================

    CPI LED_STATE, 1
    BRNE FIM_SORTEIO

    ; Se LED_STATE = 1, ganha e acende fixo. Se LED_STATE = 2, ganha e fica piscando (via MAIN_LOOP)
    IN AUX, PORTB
    ORI AUX, (1<<PB3)
    OUT PORTB, AUX

FIM_SORTEIO:
    LDI BUTTON_PRESSED_FLAG, 0

    LDI AUX, (1<<INTF0)
    OUT EIFR, AUX

    RJMP MAIN_LOOP

; ==========================================
; SUBROTINA: MÓDULO 10
; Recebe valor em AUX, subtrai 10 até ficar < 10.
; Retorna o resto da divisão em AUX.
; ==========================================
MODULO_10:
    CPI AUX, 10
    BRLO FIM_MOD
    SUBI AUX, 10
    RJMP MODULO_10
FIM_MOD:
    RET
