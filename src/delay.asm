; ==========================================
; SUBROTINA: DELAY
; ==========================================
DELAY_MS:
    PUSH r29
    PUSH r17
    PUSH r16
LOOP_EXTERNO:
    LDI r17, 21
LOOP_MEIO:
    LDI r16, 250
LOOP_INTERNO:
    DEC r16
    BRNE LOOP_INTERNO
    DEC r17
    BRNE LOOP_MEIO
    DEC r29
    BRNE LOOP_EXTERNO
    POP r16
    POP r17
    POP r29
    RET