# Módulo: animação

**Arquivo:** `src/sorteio.asm` (label `INICIA_ANIMACAO`)

Animação de rolagem dos displays após o sorteio em três fases.

---

## Estrutura geral

```
INICIA_ANIMACAO
  ├─ FASE 1 (30 iterações) — todos os 3 dígitos giram
  │     └─ trava DIGIT_UNIT = RESULT_UNIT
  ├─ FASE 2 (20 iterações) — dezena e centena giram
  │     └─ trava DIGIT_TENS = RESULT_TENS
  └─ FASE 3 (12 iterações) — só a centena gira
        └─ trava DIGIT_HUNDREDS = RESULT_HUNDREDS
```

A animação revela os dígitos da direita para a esquerda (unidade → dezena → centena), como em máquinas caça-níqueis reais.

---

## Delay progressivo

`DELAY_AUX` começa em 8 ms e é incrementado a cada iteração:

| Fase | Incremento por iteração | Delay final |
|---|---|---|
| FASE 1 | +1 ms | até ~38 ms |
| FASE 2 | +2 ms | continua crescendo |
| FASE 3 | +4 ms | desaceleração mais perceptível |

O efeito é uma rolagem que começa rápida e vai desacelerando gradualmente, simulando o comportamento mecânico de um caça-níqueis.

---

## Incremento circular dos dígitos

Cada fase incrementa o dígito e reseta para 0 quando atinge 10:

```asm
INC DIGIT_UNIT
CPI DIGIT_UNIT, 10
BRNE F1_D2
LDI DIGIT_UNIT, 0
```

Os dígitos são exibidos em tempo real pela ISR `TIMER0_OVF`, que lê `DIGIT_UNIT/TENS/HUNDREDS` continuamente.
