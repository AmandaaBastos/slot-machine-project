SRCDIR   = src
TESTDIR  = tests
SRC      = $(SRCDIR)/main.asm
OUTDIR   = build
HEX      = $(OUTDIR)/main.hex
PORT     = /dev/ttyACM0

.PHONY: all build flash clean test test_vitoria_777 test_vitoria_normal test_derrota

all: build

build:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(HEX) $(SRC)
	@rm -f $(SRCDIR)/*.obj $(SRCDIR)/*.eep.hex

# Compila todos os testes
test: test_vitoria_777 test_vitoria_normal test_derrota

test_vitoria_777:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(OUTDIR)/test_vitoria_777.hex $(TESTDIR)/test_vitoria_777.asm
	@rm -f $(TESTDIR)/*.obj $(TESTDIR)/*.eep.hex

test_vitoria_normal:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(OUTDIR)/test_vitoria_normal.hex $(TESTDIR)/test_vitoria_normal.asm
	@rm -f $(TESTDIR)/*.obj $(TESTDIR)/*.eep.hex

test_derrota:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(OUTDIR)/test_derrota.hex $(TESTDIR)/test_derrota.asm
	@rm -f $(TESTDIR)/*.obj $(TESTDIR)/*.eep.hex

flash: build
	avrdude -c arduino -p m328p -P $(PORT) -b 115200 -U flash:w:$(HEX):i

flash_test_vitoria_777: test_vitoria_777
	avrdude -c arduino -p m328p -P $(PORT) -b 115200 -U flash:w:$(OUTDIR)/test_vitoria_777.hex:i

flash_test_vitoria_normal: test_vitoria_normal
	avrdude -c arduino -p m328p -P $(PORT) -b 115200 -U flash:w:$(OUTDIR)/test_vitoria_normal.hex:i

flash_test_derrota: test_derrota
	avrdude -c arduino -p m328p -P $(PORT) -b 115200 -U flash:w:$(OUTDIR)/test_derrota.hex:i

clean:
	rm -rf $(OUTDIR)