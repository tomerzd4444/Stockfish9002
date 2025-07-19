# PREFACE:
# This Makefile is not very good but I couldn't find a way for it to both
# compile everytime I change a file which isn't main.asm and also won't
# compile all of the other files twice so I'm doing it in a very bad way but it works

# Directories
SRC_DIR = src
BUILD_DIR = build

# Compiler and linker
AS = nasm
LD = ld

# Compiler flags
AS_FLAGS = -f elf64 -g       # Compile with debug symbols
LD_FLAGS = -o chess_bot -g   # Link with debug symbols

# Find all .asm files in the src/ directory
ASM_FILES = $(wildcard $(SRC_DIR)/*.asm)

# Object file
OBJ_MAIN = $(BUILD_DIR)/main.o

# Default target
all: chess_bot

# Rule to compile all .asm files (including main.asm) into main.o
$(OBJ_MAIN): $(ASM_FILES)
	mkdir -p $(BUILD_DIR)
	$(AS) $(AS_FLAGS) -o $@ src/main.asm

# Rule to link the object file into the final executable
chess_bot: $(OBJ_MAIN)
	$(LD) $(LD_FLAGS) $(OBJ_MAIN)

# Clean up build files
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
