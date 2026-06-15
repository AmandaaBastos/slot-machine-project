; ==========================================
; INTERRUPÇÃO: BOTAO_INT (Botão - INT0)
; ==========================================
BOTAO_INT:
    PUSH r16
    IN r16, SREG
    PUSH r16

    LDI r16, 1
    CPI R18, 0
    BRNE IGNORA_BOTAO
    MOV R18, r16
IGNORA_BOTAO:

    POP r16
    OUT SREG, r16
    POP r16
    RETI