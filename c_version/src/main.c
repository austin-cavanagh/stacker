#include <wiringPi.h>
#include <unistd.h>
#include <stdio.h>

// Define led gpio pins
#define RED_1 18
#define BLUE_1 23
#define RED_2 24
#define BLUE_2 25
#define RED_3 12
#define BLUE_3 16
#define RED_4 20
#define BLUE_4 21

#define NUM_LEDS 8
int ledPins[NUM_LEDS] = {
    RED_1,
    BLUE_1,
    RED_2,
    BLUE_2,
    RED_3,
    BLUE_3,
    RED_4,
    BLUE_4
};

// Define button pin
#define PIN_BUTTON 4

void turnOnLeds();
void turnOffLeds();

void configurePins();
void startAnimation();
void flashColorSpecificLeds();

int blinkLed(int ledPin, int blinkDuration);
int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay);

void endAnimation(int blinkCount, int blinkDuration);
void playGame();

int main(void) {
    // Configure gpio pins used for the game
    configurePins();

    // Display start animation until button is pressed
    startAnimation();

    // Play the game
    playGame();

    // Display end animation after completing the game
    endAnimation(10, 250);

    return 0;
}

// Function handles core game logic
void playGame() {
    int curLed = 0;

    // Loop until curLed equals NUM_LEDS
    while (curLed < NUM_LEDS) {
        // Blink current LED and get success or failure from button press
        int success = blinkLed(ledPins[curLed], 2000);
        
        // Determine if press was a success or failure
        if (success) {
            curLed++;
        } else {
            curLed = 0;
            turnOffLeds();
        }
    }
}

// Function handles blinking each LED and logic for button pressing
int blinkLed(int ledPin, int blinkDuration) {
    // Debouncing variables
    int buttonState = LOW;         
    int lastButtonReading = LOW;   
    unsigned long lastDebounceTime = 0;
    unsigned long debounceDelay = 25;

    // Wait to start the LED blinking until the button is released from last press
    while (digitalRead(PIN_BUTTON) == HIGH) {
        delay(5);
    }

    // Loop until the button is pressed
    while (1) {
        // Variable to handle blinking timing
        int elapsedTime = 0;

        // LED ON logic
        digitalWrite(ledPin, HIGH);
        elapsedTime = 0;
        while (elapsedTime < blinkDuration) {
            int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 1, debounceDelay);
            if (result != -1) {
                return result; 
            }
            delay(1);
            elapsedTime += 1;
        }

        // LED OFF logic
        digitalWrite(ledPin, LOW);
        elapsedTime = 0;
        while (elapsedTime < blinkDuration) {
            int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 0, debounceDelay);
            if (result != -1) {
                return result; 
            }
            delay(1);
            elapsedTime += 1;
        }
    }
}

// Function checks for a stable button press with debouncing logic
int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay) {
    // Variable to handle the current button reading
    int curButtonReading = digitalRead(PIN_BUTTON);

    // When a change is the button state is detected restart the doubounce timer
    if (curButtonReading != *lastButtonReading) {
        *lastDebounceTime = millis();
    }

    // If the debounce timer is greater than the debounce delay 
    if ((millis() - *lastDebounceTime) > debounceDelay) {
        // And the new reading is different update the button state
        if (curButtonReading != *buttonState) {
            *buttonState = curButtonReading;

            // If the new button state is high it means the button was pressed
            if (*buttonState == HIGH) {
                if (ledOn) {
                    // Return 1 if button pressed while LED is ON
                    return 1;
                } else {
                    // Return 0 if button pressed while LED is ON
                    return 0;
                }
            }
        }
    }

    // Update the last button reading with the current button reading
    *lastButtonReading = curButtonReading;

    // Return -1 for no button press
    return -1;
}

// Function handles the end annimation after the game ends
void endAnimation(int blinkCount, int blinkDuration) {
    // Run animation based on blink count argument variable
    for (int i = 0; i < blinkCount; i++) {
        // Turn on blue LEDs
        for (int i = 0; i < NUM_LEDS; i++) {
            if (i == 1 || i == 3 || i == 5 || i == 7) {
                digitalWrite(ledPins[i], HIGH);
            }
        }

        delay(blinkDuration);

        // Turn off blue LEDs
        for (int i = 0; i < NUM_LEDS; i++) {
            if (i == 1 || i == 3 || i == 5 || i == 7) {
                digitalWrite(ledPins[i], LOW);
            }
        }

        // Turn on red LEDs
        for (int i = 0; i < NUM_LEDS; i++) {
                // Red LEDs at indices 0, 2, 4, 6
                if (i == 0 || i == 2 || i == 4 || i == 6) {
                    digitalWrite(ledPins[i], HIGH);
                }
        }

        delay(blinkDuration);

        // Turn off red LEDs
        for (int i = 0; i < NUM_LEDS; i++) {
                if (i == 0 || i == 2 || i == 4 || i == 6) {
                    digitalWrite(ledPins[i], LOW);
                }
        }
    }
}

// Function turns on all LEDs
void turnOnLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], HIGH);
    }
}

// Function turns off all LEDs
void turnOffLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], LOW);
    }
}





// Function configures the gpio pins used for the game
void configurePins() {
    // Initialize gpio with wiringpi setup
    wiringPiSetupGpio();

    // Set each led pin as an output
    for (int i = 0; i < NUM_LEDS; i++) {
        pinMode(ledPins[i], OUTPUT);
    }

    // Set the button pin as an input
    pinMode(PIN_BUTTON, INPUT);
}

// Function handles the start annimation before the button is pressed to start the game
void startAnimation() {
    // Variable to hold button state
    int buttonState;

    // Loop through the animation until the button is pressed
    while (1) {
        // Light LEDs from start to end
        for (int i = 0; i < NUM_LEDS; i++) {
            digitalWrite(ledPins[i], HIGH);
            delay(40); 
            digitalWrite(ledPins[i], LOW); 
            delay(40);

            // Exit function to start game if button is pressed
            buttonState = digitalRead(PIN_BUTTON);
            if (buttonState == HIGH) {
                return; 
            }
        }

        // Light LEDs from end to start
        for (int i = NUM_LEDS - 2; i > 0; i--) {
            digitalWrite(ledPins[i], HIGH);
            delay(40);
            digitalWrite(ledPins[i], LOW); 
            delay(40);

            // Exit function to start game if button is pressed
            buttonState = digitalRead(PIN_BUTTON);
            if (buttonState == HIGH) {
                return; 
            }
        }
    }
}