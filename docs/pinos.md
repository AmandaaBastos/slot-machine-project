# Hardware

Microcontrolador: **ATmega328P** (Arduino Uno)

---

## Pinagem

### PORTB — Controle de saída

| Pino | Bit | Função |
|---|---|---|
| PB0 | 0 | Base do transistor PNP do display 1 (unidade) |
| PB1 | 1 | Base do transistor PNP do display 1 (dezena) |
| PB2 | 2 | Base do transistor PNP do display 3 (centena) |
| PB3 | 3 | LED de vitória |

Configuração: `DDRB = 0x0F` (bits 0–3 como saída)

Valor inicial: `PORTB = 0x07` (transistores D1/D2/D3 desligados - base VCC - PNP)

### PORTD — Saídas dos displays

| Pino | Bit | Segmento |
|---|---|---|
| PD7 | 7 | A |
| PD6 | 6 | B |
| PD5 | 5 | C |
| PD4 | 4 | D |
| PD3 | 3 | E |
| PD1 | 1 | F |
| PD0 | 0 | G |
| PD2 | 2 | Botão (entrada) |

Configuração: `DDRD = 0xFB` (bit 2 como entrada, restante como saída)

Pull-up interno no botão: `PORTD = 0x04`

---

## Componentes

| Componente | Qtd | Observação |
|---|---|---|
| Display 7 segmentos ânodo comum | 3 | Catodo controlado por transistor NPN |
| Transistor NPN (ex: BC547) | 3 | Um por display |
| LED | 1 | Conectado ao PB3 |
| Push-button | 1 | Conectado ao PD2 (INT0) |
| Resistores | — | Para segmentos e base dos transistores |

---

## Circuito do botão

O botão está em PD2 com pull-up interno ativado. A interrupção INT0 é configurada para borda de subida (`ISC01=1, ISC00=1`), disparando quando o botão é solto (evita acionamento duplo durante o bounce inicial).

---

## Timer0

Utilizado com duas funções simultâneas:

1. **Multiplexação dos displays** — a interrupção `TIMER0_OVF` alterna entre os 3 displays a cada overflow
2. **Fonte de entropia** — o valor de `TCNT0` no momento do clique serve como semente aleatória

Prescaler: `CS01=1, CS00=1` → divisão por 64 → ~977 Hz de overflow a 16 MHz
