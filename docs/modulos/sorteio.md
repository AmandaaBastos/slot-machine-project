# Módulo: sorteio

**Arquivo:** `src/sorteio.asm` (label `CALCULA_RESULTADO`)

Lógica de probabilidade do caça-níqueis. Executada a partir do `MAIN_LOOP` quando `BUTTON_PRESSED_FLAG == 1`.

---

## Fonte de entropia

```asm
IN AUX_2, TCNT0   ; lê o contador do Timer0 (0–255)
```

O `TCNT0` está em contagem livre com prescaler /64 (~977 Hz de overflow). O valor lido no momento exato do clique é imprevisível para o usuário, funcionando como semente aleatória.

---

## Distribuição de probabilidade

| Resultado | Probabilidade |
|---|---|
| Vitória Jackpot (777) | 5% |
| Vitória normal | 10% |
| Derrota | 85% |

> O resultado é obtido pelo valor do Timer0.

---

## Casos

### Vitória 777
- `RESULT_UNIT = RESULT_TENS = RESULT_HUNDREDS = 7`
- `LED_STATE = 2` (piscar)

### Vitória normal
- Gera um dígito aleatório via `Timer 1`
- Se o dígito for 7, substitui por 8 (evita falsa vitória 777)
- `RESULT_UNIT = RESULT_TENS = RESULT_HUNDREDS = dígito`
- `LED_STATE = 1` (fixo)

### Derrota
- Busca dados do `Timer 1` para gerar os resultados de centena, dezena e unidade.

---

## Subrotina: MODULO_10

Calcula `AUX % 10` por subtração sucessiva. Recebe valor em `AUX`, retorna o resto em `AUX`.

```asm
MODULO_10:
    CPI AUX, 10
    BRLO FIM_MOD
    SUBI AUX, 10
    RJMP MODULO_10
FIM_MOD:
    RET
```

Eficiente para valores de 0–255, máximo de 25 iterações.

---

## Finalização

Após a animação, o LED é aceso conforme `LED_STATE`, `BUTTON_PRESSED_FLAG` é zerado e `INTF0` é limpo manualmente para descartar qualquer borda capturada durante o sorteio.
