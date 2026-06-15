; ==========================================
; SUBROTINA: DELAY
; ==========================================
DELAY_MS:
    PUSH DELAY_AUX
    PUSH AUX_2
    PUSH AUX
LOOP_EXTERNO:
    LDI AUX_2, 21
LOOP_MEIO:
    LDI AUX, 250
LOOP_INTERNO:
    DEC AUX
    BRNE LOOP_INTERNO
    DEC AUX_2
    BRNE LOOP_MEIO
    DEC DELAY_AUX
    BRNE LOOP_EXTERNO
    POP AUX
    POP AUX_2
    POP DELAY_AUX
    RET