# Módulo: mux

**Arquivo:** `src/mux.asm`

ISR do overflow do Timer0 (`TIMER0_OVF`). Responsável pela multiplexação dos três displays de 7 segmentos.

---

## Princípio da multiplexação

Os três displays compartilham os mesmos pinos de segmento (PORTD). Apenas um display fica ativo por vez, alternando tão rápido que o olho percebe os três acesos simultaneamente.

A cada chamada da ISR, o próximo display é ativado na sequência: `D1 → D2 → D3 → D1 → ...`

---

## Fluxo da ISR

```
TIMER0_OVF
  ├─ salva AUX, AUX_2, Z na pilha
  ├─ desliga todos os transistores (PORTB |= 0x07)
  ├─ aponta Z para TABELA_7SEG
  ├─ SELECTED_DISPLAY == 0? → MUX_D1 (ativa Display 1, SELECTED_DISPLAY = 1)
  ├─ SELECTED_DISPLAY == 1? → MUX_D2 (ativa Display 2, SELECTED_DISPLAY = 2)
  └─ senão               → MUX_D3 (ativa Display 3, SELECTED_DISPLAY = 0)
```

---

## Acesso à tabela via ponteiro Z

O endereço do dígito na tabela é calculado somando o valor do dígito ao endereço base:

```asm
LDI ZL, low(TABELA_7SEG * 2)
LDI ZH, high(TABELA_7SEG * 2)
ADD ZL, DIGIT_UNIT      ; desloca para o byte do dígito desejado
ADC ZH, AUX_2           ; AUX_2 = 0, propaga carry sem somar lixo
LPM AUX, Z              ; carrega o byte de segmentos da Flash
OUT PORTD, AUX
```

O `* 2` converte o endereço de palavra para endereço de byte (necessário para `LPM`).

---

## Controle dos transistores

Cada display é ativado individualmente por um transistor NPN controlado por PORTB. A lógica é invertida (ânodo comum):

| Display | Bit PORTB | Ativo em |
|---|---|---|
| D1 (unidade) | PB0 | `0` |
| D2 (dezena) | PB1 | `0` |
| D3 (centena) | PB2 | `0` |

O desligamento de todos (`PORTB |= 0x07`) antes de trocar de display evita ghosting.
