# Módulo: delay

**Arquivo:** `src/delay.asm`

Subrotina de delay por software bloqueante.


---

## Implementação

Três loops aninhados com contagens fixas:

```asm
DELAY_MS:
    PUSH DELAY_AUX
    PUSH AUX_2
    PUSH AUX
LOOP_EXTERNO:           ; repete DELAY_AUX vezes
    LDI AUX_2, 21
LOOP_MEIO:              ; repete 21 vezes
    LDI AUX, 250
LOOP_INTERNO:           ; repete 250 vezes
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
```

---

## Cálculo de ciclos

A 16 MHz, 1 ciclo = 62,5 ns.

| Loop | Iterações | Ciclos por iteração |
|---|---|---|
| LOOP_INTERNO | 250 | 2 (DEC + BRNE) |
| LOOP_MEIO | 21 | ~502 (250×2 + overhead) |
| LOOP_EXTERNO | DELAY_AUX | ~10.542 (21×502 + overhead) |

`DELAY_AUX = 1` → ~10.542 ciclos → ~659 µs

O valor 21 foi ajustado empiricamente para aproximar 1 ms por unidade de `DELAY_AUX`. Não é preciso ao nível de µs, mas suficiente para as necessidades do projeto.
