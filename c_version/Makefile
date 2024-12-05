CC=gcc
CFLAGS=-Wall -g
LDFLAGS=-lwiringPi  # This should be correctly positioned in the linking command

SRC_DIR=./src
BUILD_DIR=./build
TARGET=$(BUILD_DIR)/stacker

all: $(TARGET)

$(TARGET): $(SRC_DIR)/main.o
	mkdir -p $(BUILD_DIR)
	$(CC) $^ -o $@ $(LDFLAGS)

$(SRC_DIR)/main.o: $(SRC_DIR)/main.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(BUILD_DIR) $(SRC_DIR)/*.o

.PHONY: all clean run
