# Caça-Níqueis em Assembly AVR

Projeto final da disciplina **MATA49 — Programação de Software Básico**.

Implementação de um caça-níqueis em Assembly para o microcontrolador **ATmega328P**, com três displays de 7 segmentos multiplexados, animação de rolagem e LED de vitória.

---

## Como funciona

- Pressione o botão para iniciar o sorteio
- O resultado é baseado na entropia do Timer0 no momento exato do clique
- **5%** de chance de vitória 777 (Jackpot) (LED piscando)
- **15%** de chance de vitória normal — triplo de qualquer número exceto 7 (LED aceso)
- **85%** de chance de derrota — três dígitos diferentes

---

## Requisitos de hardware

| Componente | Quantidade utilizada |
|---|---|
| Arduino ATmega328P | 1 |
| Protoboard | 1 |
| Display 7 segmentos multiplexado (D5631AB) | 1 |
| Transistor PNP | 3 |
| LED | 1 |
| Push-button | 1 |
| Jumpers | 20 |

> Detalhes de pinagem e configuração em [pinos.md](docs/pinos.md).

---

## Como compilar e gravar

```bash
make        # builda em build/main.hex
make flash  # envia para o ATMega
```

> O Makefile possui uma diretiva para remover arquivos que não sejam o .hex, caso seja necessário, remova esse item no arquivo Makefile ou compile manualmente utilizando o avra 

---

## Documentação

| Documento | Descrição |
|---|---|
| [Pinos](docs/pinos.md) | Pinagem, componentes e circuito |
| [Registradores](docs/registradores.md) | Mapa completo de registradores |

### Módulos

| Módulo | Arquivo | Descrição |
|---|---|---|
| [main](docs/modulos/main.md) | `src/main.asm` | Setup, vetores de interrupção e loop principal |
| [botao](docs/modulos/botao.md) | `src/botao.asm` | ISR INT0 — leitura do botão |
| [sorteio](docs/modulos/sorteio.md) | `src/sorteio.asm` | Lógica de probabilidade e sorteio |
| [animacao](docs/modulos/animacao.md) | `src/sorteio.asm` | Animação de rolagem em 3 fases |
| [mux](docs/modulos/mux.md) | `src/mux.asm` | ISR Timer0 — multiplexação dos displays |
| [delay](docs/modulos/delay.md) | `src/delay.asm` | Subrotina de delay por software |
| [tabela](docs/modulos/tabela.md) | `src/tabela.asm` | Codificação 7 segmentos |


# Integrantes
- Amanda Bastos de Melo
- André Luiz de Oliveira Junior
- Celso Santos Bomfim Junior
- Eduardo Lazarini Fontana
- Jean Carlo Moreira de Oliveira
