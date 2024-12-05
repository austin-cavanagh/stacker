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

void turnOnAllLeds();
void turnOnOFFLeds();

int main(void) {
    // Initialize gpio with wiringpi setup
    wiringPiSetupGpio();

    // Set each led pin as an output
    for (int i = 0; i < NUM_LEDS; i++) {
        pinMode(ledPins[i], OUTPUT);
    }

    // turnOnAllLeds();
    turnOnOFFLeds();

    // // Set the button pin as an input
    // pinMode(PIN_BUTTON, INPUT);

    // int lastButtonState = LOW; // the previous reading from the input pin
    // int buttonState; // the current reading from the input pin
    // unsigned long lastDebounceTime = 0; // the last time the output pin was toggled
    // unsigned long debounceDelay = 25; // the debounce time; increase if the output flickers

    // while (1) {
    //     int reading = digitalRead(PIN_BUTTON);

    //     // if the input changed, due to noise or pressing:
    //     if (reading != lastButtonState) {
    //         // reset the debouncing timer
    //         lastDebounceTime = millis();
    //     }

    //     if ((millis() - lastDebounceTime) > debounceDelay) {
    //         // whatever the reading is at, it's been there for longer than the debounce
    //         // delay, so take it as the actual current state:
    //         // if the button state has changed:
    //         if (reading != buttonState) {
    //             buttonState = reading;

    //             // only toggle the LED if the new button state is HIGH
    //             if (buttonState == HIGH) {
    //                 printf("Pressed Button!\n");
    //             }
    //         }
    //     }

    //     // save the reading. Next time through the loop, it'll be the lastButtonState:
    //     lastButtonState = reading;

    //     delay(1); // Small delay to prevent CPU overutilization
    // }

    return 0;
}


// Function to turn on all leds
void turnOnAllLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], HIGH);
    }
}

// Function to turn off all leds
void turnOnOFFLeds() {
    for (int i = 0; i < NUM_LEDS; i++) {
        digitalWrite(ledPins[i], LOW);
    }
}