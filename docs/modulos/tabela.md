# Módulo: tabela

**Arquivo:** `src/tabela.asm`

Tabela de lookup para codificação dos dígitos 0–9 em display de 7 segmentos.

---

## Tipo de display

**Ânodo comum** — segmento aceso com nível lógico `0`.

Mapeamento dos segmentos nos pinos de PORTD:

| Segmento | Pino |
|---|---|
| A | PD7 |
| B | PD6 |
| C | PD5 |
| D | PD4 |
| E | PD3 |
| F | PD1 |
| G | PD0 |

---

## Tabela

| Índice | Dígito | Byte |
|---|---|---|
| 0 | 0 | `0x05` |
| 1 | 1 | `0x9F` |
| 2 | 2 | `0x26` |
| 3 | 3 | `0x0E` |
| 4 | 4 | `0x9C` |
| 5 | 5 | `0x4C` |
| 6 | 6 | `0x44` |
| 7 | 7 | `0x1F` |
| 8 | 8 | `0x04` |
| 9 | 9 | `0x0C` |
| 10 | - | `0xFE` |

---

## Acesso

A tabela é armazenada na Flash e acessada via instrução `LPM`, mesma lógica utilizada em sala de aula, com o ponteiro Z. Ver [mux.md](mux.md) para o código de acesso.
