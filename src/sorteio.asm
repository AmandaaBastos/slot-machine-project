; ==========================================
; ETAPA 1: LÓGICA DE SORTEIO (20% CHANCE)
; ==========================================
CALCULA_RESULTADO:
    in r16, PORTB
    andi r16, ~(1<<PB3)
    out PORTB, r16

    ; 1. LÊ A ENTROPIA DO HARDWARE NO MOMENTO EXATO DO CLIQUE
    in r17, TCNT0       ; R17 = Valor Aleatório (0 a 255)

    ; 2. CALCULA A CHANCE DE VITÓRIA (20% de 255 é aprox. 51)
    cpi r17, 51
    brlo DEU_VITORIA    ; Se R17 for menor que 51, ganhou!

DEU_DERROTA:
    ; Gera o Dígito 1
    mov r16, r17
    rcall MODULO_10
    mov R26, r16

    ; Gera o Dígito 2 (Adiciona salto primo para ser diferente)
    mov r16, r17
    ldi r23, 43
    add r16, r23
    rcall MODULO_10
    mov R27, r16

    ; Gera o Dígito 3
    mov r16, r17
    ldi r23, 107
    add r16, r23
    rcall MODULO_10
    mov R28, r16

    ; Impede que haja uma falsa vitória na derrota
    cp R26, R27
    brne INICIA_ANIMACAO
    cp R27, R28
    brne INICIA_ANIMACAO

    ; Se os 3 ficarem iguais por acidente, altera o último
    inc R28
    mov r16, R28
    rcall MODULO_10
    mov R28, r16
    rjmp INICIA_ANIMACAO

DEU_VITORIA:
    ; Pega um número aleatório (0 a 9) e estampa nos 3 displays
    mov r16, r17
    rcall MODULO_10
    mov R26, r16
    mov R27, r16
    mov R28, r16

; ==========================================
; ETAPA 2: ANIMAÇÃO EM 3 FASES
; ==========================================
INICIA_ANIMACAO:
    ldi R29, 8

    ; FASE 1
    ldi R25, 30
FASE_1:
    inc R20
    cpi R20, 10
    brne F1_D2
    ldi R20, 0
F1_D2:
    inc R21
    cpi R21, 10
    brne F1_D3
    ldi R21, 0
F1_D3:
    inc R22
    cpi R22, 10
    brne F1_DELAY
    ldi R22, 0
F1_DELAY:
    rcall DELAY_MS
    inc R29
    dec R25
    brne FASE_1

    mov R20, R26

    ; FASE 2
    ldi R25, 20
FASE_2:
    inc R21
    cpi R21, 10
    brne F2_D3
    ldi R21, 0
F2_D3:
    inc R22
    cpi R22, 10
    brne F2_DELAY
    ldi R22, 0
F2_DELAY:
    rcall DELAY_MS
    inc R29
    inc R29
    dec R25
    brne FASE_2

    mov R21, R27

    ; FASE 3
    ldi R25, 12
FASE_3:
    inc R22
    cpi R22, 10
    brne F3_DELAY
    ldi R22, 0
F3_DELAY:
    rcall DELAY_MS
    inc R29
    inc R29
    inc R29
    inc R29
    dec R25
    brne FASE_3

    mov R22, R28

; ==========================================
; ETAPA 3: FINALIZA E EXIBE
; ==========================================
    cp R20, R21
    brne FIM_SORTEIO
    cp R21, R22
    brne FIM_SORTEIO

    in r16, PORTB
    ori r16, (1<<PB3)
    out PORTB, r16

FIM_SORTEIO:
    ldi R18, 0

    ldi r16, (1<<INTF0)
    out EIFR, r16

    rjmp MAIN_LOOP

; ==========================================
; SUBROTINA: MÓDULO 10
; Recebe valor em R16, subtrai 10 até ficar < 10.
; Retorna o resto da divisão em R16.
; ==========================================
MODULO_10:
    cpi r16, 10
    brlo FIM_MOD
    subi r16, 10
    rjmp MODULO_10
FIM_MOD:
    ret
