@echo off

if not exist build mkdir build

echo Building SM NTSC Practice Hack
python enemies\create_clear_enemies_data.py ..\src\clearenemies.asm clear_enemies.txt
python layout\create_layout.py portals.txt layoutmenutemplate.asm ..\src\layoutmenu.asm ..\src\layoutportaltables.asm
python names\create_names.py ..\src\roomnames.asm default_names.txt custom_names.txt
cd resources
python create_ram_symbols.py ..\src\defines.asm ..\src\symbols.asm
python create_dummies.py 00.sfc ff.sfc

echo Building saveless version
if exist ..\build\smhack20.ips del ..\build\smhack20.ips
copy *.sfc ..\build
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=0 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=0 ..\src\main.asm ..\build\00.sfc
if ERRORLEVEL 1 goto end_build_saveless
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=0 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=0 ..\src\main.asm ..\build\ff.sfc
python sort_debug_symbols.py ..\build\symbols.sym x ..\build\smhack20_combined.sym
python create_ips.py ..\build\00.sfc ..\build\ff.sfc ..\build\smhack20.ips
:end_build_saveless

echo Building SD2SNES version
if exist ..\build\smhack20_sd2snes.ips del ..\build\smhack20_sd2snes.ips
copy *.sfc ..\build
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=1 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=0 ..\src\main.asm ..\build\00.sfc
if ERRORLEVEL 1 goto end_build_sd2snes
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=1 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=0 ..\src\main.asm ..\build\ff.sfc
python sort_debug_symbols.py ..\build\symbols.sym x ..\build\smhack20_sd2snes.sym
python create_ips.py ..\build\00.sfc ..\build\ff.sfc ..\build\smhack20_sd2snes.ips
:end_build_sd2snes

echo Building TinyStates version
if exist ..\build\smhack20_tinystates.ips del ..\build\smhack20_tinystates.ips
copy *.sfc ..\build
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=0 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=1 ..\src\main.asm ..\build\00.sfc
if ERRORLEVEL 1 goto end_build_tinystates
..\tools\asar --no-title-check --symbols=wla --symbols-path=..\build\symbols.sym -DFEATURE_SD2SNES=0 -DFEATURE_PAL=0 -DFEATURE_TINYSTATES=1 ..\src\main.asm ..\build\ff.sfc
python sort_debug_symbols.py ..\build\symbols.sym x ..\build\smhack20_tinystates.sym
python create_ips.py ..\build\00.sfc ..\build\ff.sfc ..\build\smhack20_tinystates.ips
:end_build_tinystates

del 00.sfc ff.sfc ..\build\00.sfc ..\build\ff.sfc ..\build\symbols.sym
cd ..
