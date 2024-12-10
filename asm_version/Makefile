# Compiler and assembler settings
# - Change the compiler to gcc and assembler to as
# - Enable all warnings (-Wall)
# - Enable debugging symbols (-g)
CC = gcc
AS = as

# Linker flags 
# - Attach the wiringPi library to the executable
LDFLAGS = -lwiringPi

# Directories 
# - Specify where the source files and build output will go
SRC_DIR = src
BUILD_DIR = build

# Source files
C_SRC = $(SRC_DIR)/blinkLed.c
ASM_SRC = $(SRC_DIR)/main.s

# Object files
OBJ = $(BUILD_DIR)/blinkLed.o $(BUILD_DIR)/main.o

# Default target
all: $(BUILD_DIR)/stacker  

# Linking 
# - Create the final executable from all object files
$(BUILD_DIR)/stacker: $(OBJ)  
	$(CC) -o $@ $^ $(LDFLAGS)

# Compilation pattern rule 
# - How to build .o from .c source files
# - Make sure the build directory exists first
$(BUILD_DIR)/blinkLed.o: $(C_SRC) | $(BUILD_DIR)
	$(CC) -c -o $@ $< $(CFLAGS)

# Assembly pattern rule
# - How to build .o from .s assembly source files
$(BUILD_DIR)/main.o: $(ASM_SRC) | $(BUILD_DIR)
	$(AS) -o $@ $<

# Ensure the build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Run target 
# - Shortcut to build and then run the executable
run: $(BUILD_DIR)/stacker 
	./$(BUILD_DIR)/stacker 

# Clean target 
# - Remove the build directory and all build files
clean:
	rm -rf $(BUILD_DIR) $(SRC_DIR)/*.o

# Declare targets that are not files as phony to ensure they always execute regardless of file states
.PHONY: all clean run