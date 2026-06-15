# Módulo: main

**Arquivo:** `src/main.asm`

Ponto de entrada do programa. Define os registradores, configura as interrupções e inicializa o hardware.

---

## Vetores de interrupção

| Endereço | Label | Destino |
|---|---|---|
| `0x0000` | RESET | `RESET` |
| `0x0002` | INT0 | `BOTAO_INT (PB2)` |
| `0x0020` | TIMER0_OVF (Overflow do Timer0) | `TIMER0_OVF` |

---

## Sequência de inicialização (RESET)

1. **PORTD** — PD2 entrada, pull-up no botão
2. **PORTB** — `DDRB = 0x0F` (PB0–PB3 saída), `PORTB = 0x07` (base do transistor)
3. **Timer0** — habilita `TOIE0` e adiciona prescaler para /64
4. **Variáveis** — zera todas as flags e dígitos
5. **INT0** — borda de subida para a interrupção e habilita `INT0`
6. **SEI** — habilita interrupções globais
7. **Debounce inicial** — aguarda 500 ms e limpa `INTF0` para ignorar interrupções fantasmas na inicialização do sistema

---

## Loop principal (MAIN_LOOP)

### Caminho
1. **Valida flag do botão**: Caso a flag esteja verdadeira, inicia o sorteio de números 
2. **Estado do LED**: Valida o estado do LED para piscar em caso de JACKPOT

> O loop não bloqueia a multiplexação dos displays, que ocorre em background via `TIMER0_OVF`.

---

## Includes

Os módulos são incluídos ao final do arquivo para montagem conjunta e melhor legibilidade do código:

```asm
.include "tabela.asm"
.include "delay.asm"
.include "mux.asm"
.include "botao.asm"
.include "sorteio.asm"
```
