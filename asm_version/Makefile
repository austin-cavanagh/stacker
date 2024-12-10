# Compiler and assembler
CC = gcc
AS = as

# Directories
SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include

# Flags
CFLAGS = -I$(INCLUDE_DIR)
LDFLAGS = -lwiringPi

# Source files
C_SRC = $(SRC_DIR)/blinkLed.c
ASM_SRC = $(SRC_DIR)/main.s

# Object files (in the build directory)
OBJ = $(BUILD_DIR)/blinkLed.o $(BUILD_DIR)/main.o

# Default target
all: $(BUILD_DIR)/main

# The final binary
$(BUILD_DIR)/main: $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

# Compile C source file(s)
$(BUILD_DIR)/blinkLed.o: $(C_SRC) | $(BUILD_DIR)
	$(CC) -c -o $@ $< $(CFLAGS)

# Assemble assembly source file(s)
$(BUILD_DIR)/main.o: $(ASM_SRC) | $(BUILD_DIR)
	$(AS) -o $@ $<

# Ensure build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean up build artifacts
clean:
	rm -rf $(BUILD_DIR) $(SRC_DIR)/*.o

# Run the program
run: $(BUILD_DIR)/main
	./$(BUILD_DIR)/main

.PHONY: all clean run