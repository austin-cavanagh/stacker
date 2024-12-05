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
void startAnimationNew();
void flashColorSpecificLeds();

int blinkLed(int ledPin, int blinkDuration);
int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay);

int main(void) {
    // Configure gpio pins used for the game
    configurePins();

    while (1) {
        turnOffLeds();
    }
    
    int curLed = 0;
    while (1) {
        int success = blinkLed(ledPins[curLed], 2000);
        if (success) {
            curLed++;
            if (curLed >= NUM_LEDS) {
                // All LEDs have been successfully pressed in sequence
                printf("You won!\n");
                return 0;
            }
        } else {
            curLed = 0;
            turnOffLeds();
        }
    }

    printf("You won!\n");

    return 0;
}



// Checks for a stable button press. Returns:
//  1 if success (LED on press)
//  0 if fail (LED off press)
// -1 if no definitive press event yet
int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay) {
    int reading = digitalRead(PIN_BUTTON);

    if (reading != *lastButtonReading) {
        *lastDebounceTime = millis();
    }

    if ((millis() - *lastDebounceTime) > debounceDelay) {
        if (reading != *buttonState) {
            *buttonState = reading;
            // If the new stable state is HIGH (button pressed)
            if (*buttonState == HIGH) {
                // If LED is ON right now, it's a success
                if (ledOn) {
                    printf("Success\n");
                    return 1;
                } else {
                    // LED is OFF right now, so it's a fail
                    printf("Fail\n");
                    return 0;
                }
            }
        }
    }

    *lastButtonReading = reading;
    return -1;
}


int blinkLed(int ledPin, int blinkDuration) {
    // Debouncing variables
    int buttonState = LOW;         
    int lastButtonReading = LOW;   
    unsigned long lastDebounceTime = 0;
    unsigned long debounceDelay = 25;

    // Before starting the LED blink cycle, ensure the button is not pressed.
    // If the user is still holding the button down, wait until it's released.
    while (digitalRead(PIN_BUTTON) == HIGH) {
        delay(5); // wait until the user releases the button
    }

    int elapsedTime = 0;

    // LED ON phase
    digitalWrite(ledPin, HIGH);
    elapsedTime = 0;
    while (elapsedTime < blinkDuration) {
        int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 1, debounceDelay);
        if (result != -1) {
            return result; // Either success (1) or fail (0)
        }
        delay(1);
        elapsedTime += 1;
    }

    // LED OFF phase
    digitalWrite(ledPin, LOW);
    elapsedTime = 0;
    while (elapsedTime < blinkDuration) {
        int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 0, debounceDelay);
        if (result != -1) {
            return result; // Either success (0) or success (1) -- but here it should fail if pressed
        }
        delay(1);
        elapsedTime += 1;
    }

    // If no press detected in either on/off phase, just repeat until a press occurs
    return blinkLed(ledPin, blinkDuration);
}








void startAnimationNew() {
    int buttonState;

    // Continuously run the animation until the button is pressed
    while (1) {
        // Light LEDs from start to end
        for (int i = 0; i < NUM_LEDS; i++) {
            digitalWrite(ledPins[i], HIGH);
            delay(30); 
            digitalWrite(ledPins[i], LOW); 
            delay(30);

            buttonState = digitalRead(PIN_BUTTON);
            if (buttonState == HIGH) {
                turnOffLeds();
                return; // Exit function and proceed to game logic
            }
        }

        // Light LEDs from end to start
        for (int i = NUM_LEDS - 2; i > 0; i--) {
            digitalWrite(ledPins[i], HIGH);
            delay(30);
            digitalWrite(ledPins[i], LOW); 
            delay(30);

            buttonState = digitalRead(PIN_BUTTON);
            if (buttonState == HIGH) {
                turnOffLeds();
                return; // Exit function and proceed to game logic
            }
        }
    }
}

// Functiom performs the starting animation
void startAnimation() {
    // Light leds to end
    for (int i = 0; i < NUM_LEDS; i++) {
        // Light up current led
        digitalWrite(ledPins[i], HIGH);
        delay(30); 
        // Turn off current led
        digitalWrite(ledPins[i], LOW); 
        delay(30); 
    }

    // Light leds to start
    // Start from the second to last led so it does not light 2 times
    // End before the first led so loop begins at first led again
    for (int i = NUM_LEDS - 2; i > 0; i--) {  
        // Light up current led
        digitalWrite(ledPins[i], HIGH);
        delay(30);
        // Turn off current led
        digitalWrite(ledPins[i], LOW); 
        delay(30); 
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

// Function to turn on all leds
void turnOnLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], HIGH);
    }
}

// Function to turn off all leds
void turnOffLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], LOW);
    }
}