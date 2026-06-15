SRCDIR  = src
SRC     = $(SRCDIR)/main.asm
OUTDIR  = build
HEX     = $(OUTDIR)/main.hex
PORT    = /dev/ttyACM0

.PHONY: all build flash clean

all: build

build:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(HEX) $(SRC)
	@rm -f $(SRCDIR)/*.obj $(SRCDIR)/*.eep.hex

flash: build
	avrdude -c arduino -p m328p -P $(PORT) -b 115200 -U flash:w:$(HEX):i

clean:
	rm -rf $(OUTDIR)