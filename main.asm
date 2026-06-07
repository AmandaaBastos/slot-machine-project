; ======================================================================
; PROJETO FINAL MATA49 - CAÇA-NÍQUEIS 
; Sorteio Dinâmico por Entropia de Hardware (TCNT0)
; 20% de Vitória | Combinações de 000 a 999
;======================================================================

.include "m328Pdef.inc"

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
    ldi R24, 0    ; flagzinha do led. Coloquei pra 0 = desliga, 1=liga 2 2 pisca

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
; LOOP PRINCIPAL (AGUARDANDO BOTÃO E PISCANDO)
; ==========================================
MAIN_LOOP:
    cpi R18, 1
    breq CALCULA_RESULTADO
    
   
    cpi R24, 2
    brne MAIN_LOOP
    
    ;lógica do led
    ldi R29, 100     
    rcall DELAY_MS
    in r16, PORTB
    ldi r17, (1<<PB3)
    eor r16, r17        
    out PORTB, r16

    rjmp MAIN_LOOP

; ==========================================
; ETAPA 1: ETAPA 1: LÓGICA DE SORTEIO (20% CHANCE)
; ==========================================
CALCULA_RESULTADO:
    
    in r16, PORTB
    andi r16, ~(1<<PB3)
    out PORTB, r16
    ldi R24, 0   ; Reset do led p/ prox rodada

    ; 1. LÊ A ENTROPIA DO HARDWARE NO MOMENTO EXATO DO CLIQUE
    in r17, TCNT0       ; R17 = Valor Aleatório (0 a 255)

    ; 2. 20% para vitória
    cpi r17, 51
    brlo DEU_VITORIA_777; Vitoria

    ;2.1 40% para vitoria normal
    cpi r17, 102
    brlo DEU_VITORIA_NORMAL
    
    ; o resto da porcentagem para Bahia(calma, esporte-clube derrota, é só uma piada...)
    rjmp DEU_DERROTA

DEU_VITORIA_777:
    ldi r16, 7
    mov R26, r16
    mov R27, r16
    mov R28, r16
    ldi R24, 2   ; ativa o modo blink  
    rjmp INICIA_ANIMACAO

DEU_VITORIA_NORMAL:
    ; Pega um número aleatório (0 a 9)
    mov r16, r17
    rcall MODULO_10
    
    ; Essa logica, impede de da vitria normal poder ser 77 também
    cpi r16, 7
    brne APLICA_VITORIA_NORMAL
    ldi r16, 8          ; Se der 7, transforma em 8
    
APLICA_VITORIA_NORMAL:
    mov R26, r16
    mov R27, r16
    mov R28, r16
    ldi R24, 1   ; led ligado
    rjmp INICIA_ANIMACAO

DEU_DERROTA:
    ; Gera o Dígito 1
    mov r16, r17
    rcall MODULO_10
    mov R26, r16

    ; Gera o Dígito 2
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
    
    cpi R24, 1
    brne FIM_SORTEIO

    ; Se R24 = 1 , GG e acende fixo. se for pra 2 GG e fica piscando
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

; ==========================================
; SUBROTINA: DELAY 
; ==========================================
DELAY_MS:
    push r29
    push r17
    push r16
LOOP_EXTERNO:
    ldi r17, 21
LOOP_MEIO:
    ldi r16, 250
LOOP_INTERNO:
    dec r16
    brne LOOP_INTERNO
    dec r17
    brne LOOP_MEIO
    dec r29
    brne LOOP_EXTERNO
    pop r16
    pop r17
    pop r29
    ret

; ==========================================
; INTERRUPÇÕES (BOTÃO E MULTIPLEXAÇÃO)
; ==========================================
BOTAO_INT:
    push r16
    in r16, SREG
    push r16

    ldi r16, 1
    cpi R18, 0
    brne IGNORA_BOTAO
    mov R18, r16
IGNORA_BOTAO:

    pop r16
    out SREG, r16
    pop r16
    reti

TIMER0_OVF:
    push r16
    in r16, SREG
    push r16
    push r17
    push r30
    push r31

    ldi r17, 0

    in r16, PORTB
    ori r16, 0x07       
    out PORTB, r16

    ldi ZL, low(TABELA_7SEG * 2)
    ldi ZH, high(TABELA_7SEG * 2)

    cpi R19, 0
    breq MUX_D1
    cpi R19, 1
    breq MUX_D2

MUX_D3:
    add ZL, R22
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB       
    andi r16, ~(1<<PB2) 
    out PORTB, r16
    ldi R19, 0
    rjmp MUX_SAIR

MUX_D1:
    add ZL, R20         
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB
    andi r16, ~(1<<PB0) 
    out PORTB, r16
    ldi R19, 1
    rjmp MUX_SAIR

MUX_D2:
    add ZL, R21         
    adc ZH, r17
    lpm r16, Z
    out PORTD, r16
    in r16, PORTB
    andi r16, ~(1<<PB1) 
    out PORTB, r16
    ldi R19, 2

MUX_SAIR:
    pop r31
    pop r30
    pop r17
    pop r16
    out SREG, r16
    pop r16
    reti

; ==========================================
; TABELA DE CARACTERES
; (Ânodo Comum - A no PD7, Botão no PD2)
; ==========================================
TABELA_7SEG:
    .db 0x05, 0x9F, 0x26, 0x0E, 0x9C, 0x4C, 0x44, 0x1F, 0x04, 0x0C