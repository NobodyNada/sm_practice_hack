#!/usr/bin/env python
import io
import os
import sys

if len(sys.argv) != 3:
   print("create_ram_symbols.py <defines_file> <new_symbol_file>")
   sys.exit()
else:
   defines_name = sys.argv[1]
   new_symbols_name = sys.argv[2]

defines_file = io.open(os.path.join(os.path.dirname(os.path.realpath(__file__)), defines_name), "r")
define_lines = defines_file.readlines()
defines_file.close()

symbols_file = io.open(os.path.join(os.path.dirname(os.path.realpath(__file__)), new_symbols_name), "w", newline='\n')
symbols_file.write("\n; ---------------")
symbols_file.write("\n; Symbol Export")
symbols_file.write("\n; ---------------")
symbols_file.write("\n\nincsrc wram_symbols.asm\n\n")

last_line_was_new_line = True
for line in define_lines:
   if len(line) <= 2:
      if not last_line_was_new_line:
         symbols_file.write(line)
      last_line_was_new_line = True
   elif line[0] == ';':
      if line.startswith("; Vanilla Labels"):
         break
      symbols_file.write(line)
      last_line_was_new_line = False
   elif line[0] == '!' and line[1].lower() == line[1]:
      parts = line.split('=')
      if len(parts) == 2:
         ram_symbol = parts[0].strip()
         symbols_file.write(ram_symbol[1:])
         symbols_file.write(" = ")
         symbols_file.write(ram_symbol)
         symbols_file.write(" ;")
         symbols_file.write(parts[1])
         last_line_was_new_line = False

symbols_file.close()

