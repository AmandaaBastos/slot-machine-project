; ==========================================
; INTERRUPÇÃO: BOTAO_INT (Botão - INT0)
; ==========================================
BOTAO_INT:
    PUSH AUX
    IN AUX, SREG
    PUSH AUX

    LDI AUX, 1
    CPI BUTTON_PRESSED_FLAG, 0
    BRNE IGNORA_BOTAO
    MOV BUTTON_PRESSED_FLAG, AUX
IGNORA_BOTAO:

    POP AUX
    OUT SREG, AUX
    POP AUX
    RETI