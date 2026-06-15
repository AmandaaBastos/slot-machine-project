# Módulo: botao

**Arquivo:** `src/botao.asm`

ISR da interrupção externa INT0, disparada pelo push-button em PD2.

---

## Funcionamento

A ISR não processa o sorteio diretamente — apenas seta uma flag. O processamento ocorre no `MAIN_LOOP`.

```
BOTAO_INT (ISR)
  ├─ salva AUX e SREG na pilha
  ├─ BUTTON_PRESSED_FLAG == 0?
  │    └─ sim → BUTTON_PRESSED_FLAG = 1
  │    └─ não → ignora (botão já estava pressionado)
  └─ restaura SREG e AUX, RETI
```

**Por que usar flag e não processar na ISR?**

O sorteio e a animação levam centenas de milissegundos. Executar isso dentro de uma ISR bloquearia outras interrupções — inclusive o `TIMER0_OVF` responsável pela multiplexação dos displays. Usando a flag, a ISR retorna rapidamente e o processamento ocorre no contexto do loop principal, onde as interrupções continuam ativas.

---

## Configuração (em main.asm)

```asm
LDI AUX, (1<<ISC01) | (1<<ISC00)   ; borda de subida
STS EICRA, AUX
LDI AUX, (1<<INT0)
OUT EIMSK, AUX
```

Borda de subida garante que o disparo ocorra quando o botão é **solto**, não quando é pressionado. Isso reduz problemas de bounce no acionamento inicial.
