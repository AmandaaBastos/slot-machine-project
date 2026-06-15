; ==========================================
; ETAPA 1: LÓGICA DE SORTEIO (20% CHANCE)
; ==========================================
CALCULA_RESULTADO:
    IN r16, PORTB
    ANDI r16, ~(1<<PB3)
    OUT PORTB, r16
    LDI R24, 0   ; Reset do led p/ prox rodada

    ; 1. LÊ A ENTROPIA DO HARDWARE NO MOMENTO EXATO DO CLIQUE
    IN r17, TCNT0       ; R17 = Valor Aleatório (0 a 255)

    ; 2. 20% para vitória 777
    CPI r17, 51
    BRLO DEU_VITORIA_777

    ; 3. 20% para vitória normal
    CPI r17, 102
    BRLO DEU_VITORIA_NORMAL

    ; 4. resto da porcentagem derrota
    RJMP DEU_DERROTA

DEU_VITORIA_777:
    LDI r16, 7
    MOV R26, r16
    MOV R27, r16
    MOV R28, r16
    LDI R24, 2   ; ativa o modo blink
    RJMP INICIA_ANIMACAO

DEU_VITORIA_NORMAL:
    ; Pega um número aleatório (0 a 9)
    MOV r16, r17
    RCALL MODULO_10

    ; Impede que vitória normal também seja 7
    CPI r16, 7
    BRNE APLICA_VITORIA_NORMAL
    LDI r16, 8          ; Se der 7, transforma em 8

APLICA_VITORIA_NORMAL:
    MOV R26, r16
    MOV R27, r16
    MOV R28, r16
    LDI R24, 1   ; led ligado fixo
    RJMP INICIA_ANIMACAO

DEU_DERROTA:
    ; Gera o Dígito 1
    MOV r16, r17
    RCALL MODULO_10
    MOV R26, r16

    ; Gera o Dígito 2 (Adiciona salto primo para ser diferente)
    MOV r16, r17
    LDI r23, 43
    ADD r16, r23
    RCALL MODULO_10
    MOV R27, r16

    ; Gera o Dígito 3
    MOV r16, r17
    LDI r23, 107
    ADD r16, r23
    RCALL MODULO_10
    MOV R28, r16

    ; Impede que haja uma falsa vitória na derrota
    CP R26, R27
    BRNE INICIA_ANIMACAO
    CP R27, R28
    BRNE INICIA_ANIMACAO

    ; Se os 3 ficarem iguais por acidente, altera o último
    INC R28
    MOV r16, R28
    RCALL MODULO_10
    MOV R28, r16
    RJMP INICIA_ANIMACAO

; ==========================================
; ETAPA 2: ANIMAÇÃO EM 3 FASES
; ==========================================
INICIA_ANIMACAO:
    LDI R29, 8

    ; FASE 1
    LDI R25, 30
FASE_1:
    INC R20
    CPI R20, 10
    BRNE F1_D2
    LDI R20, 0
F1_D2:
    INC R21
    CPI R21, 10
    BRNE F1_D3
    LDI R21, 0
F1_D3:
    INC R22
    CPI R22, 10
    BRNE F1_DELAY
    LDI R22, 0
F1_DELAY:
    RCALL DELAY_MS
    INC R29
    DEC R25
    BRNE FASE_1

    MOV R20, R26

    ; FASE 2
    LDI R25, 20
FASE_2:
    INC R21
    CPI R21, 10
    BRNE F2_D3
    LDI R21, 0
F2_D3:
    INC R22
    CPI R22, 10
    BRNE F2_DELAY
    LDI R22, 0
F2_DELAY:
    RCALL DELAY_MS
    INC R29
    INC R29
    DEC R25
    BRNE FASE_2

    MOV R21, R27

    ; FASE 3
    LDI R25, 12
FASE_3:
    INC R22
    CPI R22, 10
    BRNE F3_DELAY
    LDI R22, 0
F3_DELAY:
    RCALL DELAY_MS
    INC R29
    INC R29
    INC R29
    INC R29
    DEC R25
    BRNE FASE_3

    MOV R22, R28

; ==========================================
; ETAPA 3: FINALIZA E EXIBE
; ==========================================

    CPI R24, 1
    BRNE FIM_SORTEIO

    ; Se R24 = 1, ganha e acende fixo. Se R24 = 2, ganha e fica piscando (via MAIN_LOOP)
    IN r16, PORTB
    ORI r16, (1<<PB3)
    OUT PORTB, r16

FIM_SORTEIO:
    LDI R18, 0

    LDI r16, (1<<INTF0)
    OUT EIFR, r16

    RJMP MAIN_LOOP

; ==========================================
; SUBROTINA: MÓDULO 10
; Recebe valor em R16, subtrai 10 até ficar < 10.
; Retorna o resto da divisão em R16.
; ==========================================
MODULO_10:
    CPI r16, 10
    BRLO FIM_MOD
    SUBI r16, 10
    RJMP MODULO_10
FIM_MOD:
    RET
