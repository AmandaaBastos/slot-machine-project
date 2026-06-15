# Registradores

Todos os registradores de uso geral da aplicação.

| Registrador | Alias | Uso |
|---|---|---|
| R16 | `AUX` | Auxiliar geral |
| R17 | `AUX_2` | Auxiliar secundário |
| R18 | `BUTTON_PRESSED_FLAG` | Flag de botão utilizado para saber se existe a operação de sorteio pendente |
| R19 | `SELECTED_DISPLAY` | Display ativo na multiplexação do 7 segmentos: `0` = D1, `1` = D2, `2` = D3 |
| R20 | `DIGIT_UNIT` | Dígito atual da unidade (0–9) exibido no Display 1 |
| R21 | `DIGIT_TENS` | Dígito atual da dezena (0–9) exibido no Display 2 |
| R22 | `DIGIT_HUNDREDS` | Dígito atual da centena (0–9) exibido no Display 3 |
| R23 | `ANIMATION_COUNTER` | Contador de iterações de cada fase da animação |
| R24 | `LED_STATE` | Estado do LED: `0` = apagado, `1` = fixo, `2` = piscando |
| R26 | `RESULT_UNIT` | Resultado sorteado para a unidade |
| R27 | `RESULT_TENS` | Resultado sorteado para a dezena |
| R28 | `RESULT_HUNDREDS` | Resultado sorteado para a centena |
| R29 | `DELAY_AUX` | Parâmetro de entrada do `DELAY_MS` — número de milissegundos |

> Os registradores de R26-R28 e R20-22 tem papéis diferentes devido à animação realizada antes do resultado.

## Registradores de I/O relevantes utilizados no projeto

| Registrador | Uso no projeto |
|---|---|
| `TCCR0B`  | Prescaler do Timer0 |
| `TCCR1B`  | Prescaler do Timer1 |
| `TIMSK0`  | Habilita interrupção de overflow do Timer0 para a troca de displays |
| `TCNT0`  | Contador do Timer0 — fonte de entropia para determinar vitória |
| `TCNT1`  | Contador do Timer0 — fonte de entropia para o resultado numérico |
| `EICRA`  | Configura modo de disparo da INT0 |
| `EIMSK`  | Habilita INT0 |
| `EIFR`  | Flag de interrupção externa — limpo manualmente após sorteio |
