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