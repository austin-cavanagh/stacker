# Compiler settings 
# - Change the compiler to gcc
# - Enable all warnings (-Wall)
# - Enable debugging symbols (-g)
CC=gcc
CFLAGS=-Wall -g

# Linker flags 
# - Attach the wiringPi library to the executable
LDFLAGS=-lwiringPi  

# Directories 
# - Specify where the source files and build output will go
SRC_DIR=./src
BUILD_DIR=./build

# Target executable
# - Name and path of the final executable to produce
TARGET=$(BUILD_DIR)/stacker

# Source files 
# - Automatically find all C source files in the source directory
SRCS=$(wildcard $(SRC_DIR)/*.c)

# Object files 
# - Transform each source file name into an object file name
OBJS=$(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

# Default target 
# - What gets built when the user runs 'make' without arguments
all: $(TARGET)

# Linking 
# - Create the final executable from all object files
# - Make sure the build directory exists first
$(TARGET): $(OBJS)
	mkdir -p $(BUILD_DIR)
	$(CC) $^ -o $@ $(LDFLAGS)

# Compilation pattern rule 
# - How to build .o from .c source files
# - Make sure the build directory exists first
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Run target 
# - Shortcut to build and then run the executable
run: $(TARGET)
	./$(TARGET)

# Clean target 
# - Remove the build directory and all build files
clean:
	rm -rf $(BUILD_DIR)

# Declare targets that are not files as phony to ensure they always execute regardless of file state
.PHONY: all clean run