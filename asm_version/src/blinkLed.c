#include <wiringPi.h>
#include <unistd.h>
#include <stdio.h>

#define PIN_BUTTON 4
#define NUM_LEDS 8
int ledPins[NUM_LEDS] = {18, 23, 24, 25, 12, 16, 20, 21};

int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay);

int blinkLed(int ledPin, int blinkDuration) {
    int buttonState = LOW;         
    int lastButtonReading = LOW;   
    unsigned long lastDebounceTime = 0;
    unsigned long debounceDelay = 25;
    while (digitalRead(PIN_BUTTON) == HIGH) 
        delay(5);
    while (1) {
        int elapsedTime = 0;
        digitalWrite(ledPin, HIGH);
        elapsedTime = 0;
        while (elapsedTime < blinkDuration) {
            int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 1, debounceDelay);
            if (result != -1)
                return result; 
            delay(1);
            elapsedTime += 1;
        }
        digitalWrite(ledPin, LOW);
        elapsedTime = 0;
        while (elapsedTime < blinkDuration) {
            int result = checkButtonPress(&buttonState, &lastButtonReading, &lastDebounceTime, 0, debounceDelay);
            if (result != -1)
                return result; 
            delay(1);
            elapsedTime += 1;
        }
    }
}

int checkButtonPress(int *buttonState, int *lastButtonReading, unsigned long *lastDebounceTime, int ledOn, unsigned long debounceDelay) {
    int curButtonReading = digitalRead(PIN_BUTTON);
    if (curButtonReading != *lastButtonReading)
        *lastDebounceTime = millis();
    if ((millis() - *lastDebounceTime) > debounceDelay) {
        if (curButtonReading != *buttonState) {
            *buttonState = curButtonReading;
            if (*buttonState == HIGH) {
                return (ledOn) ? 1 : 0;
            }
        }
    }
    *lastButtonReading = curButtonReading;
    return -1;
}