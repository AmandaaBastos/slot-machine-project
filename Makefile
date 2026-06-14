SRCDIR	= src
SRC     = $(SRCDIR)/main.asm
OUTDIR  = build
HEX     = $(OUTDIR)/main.hex

.PHONY: all clean

all:
	@mkdir -p $(OUTDIR)
	avra -I src/ -o $(HEX) $(SRC)
	@rm -f $(SRCDIR)/*.obj $(SRCDIR)/*.eep.hex

clean:
	rm -rf $(OUTDIR)