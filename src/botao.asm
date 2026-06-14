; ==========================================
; INTERRUPÇÃO: BOTAO_INT (Botão - INT0)
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