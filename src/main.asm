lorom

!FEATURE_SD2SNES ?= 0
!FEATURE_PAL ?= 0

table ../resources/normal.tbl

incsrc macros.asm
incsrc defines.asm

; SA-1 Base support routines
incsrc sa1rom.asm
incsrc sa1.asm

incsrc gamemode.asm

if !FEATURE_SD2SNES
    print "SD2SNES ENABLED"
    incsrc save.asm
endif
incsrc minimap.asm
incsrc infohud.asm
incsrc menu.asm
incsrc rng.asm
incsrc presets.asm
incsrc misc.asm
incsrc init.asm
incsrc fanfare.asm
incsrc spriteprio.asm
incsrc spritefeat.asm

