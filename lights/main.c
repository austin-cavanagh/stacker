#include <wiringPi.h>

#define RED_1 18
#define BLUE_1 23
#define RED_2 24
#define BLUE_2 25
#define RED_3 12
#define BLUE_3 16
#define RED_4 20
#define BLUE_4 21

int main() {
    wiringPiSetupGpio();

    pinMode(RED_1, OUTPUT);
    pinMode(BLUE_1, OUTPUT);
    pinMode(RED_2, OUTPUT);
    pinMode(BLUE_2, OUTPUT);
    pinMode(RED_3, OUTPUT);
    pinMode(BLUE_3, OUTPUT);
    pinMode(RED_4, OUTPUT);
    pinMode(BLUE_4, OUTPUT);

    while (1) {
        // digitalWrite(RED_1, HIGH);
        // digitalWrite(BLUE_1, HIGH);
        // digitalWrite(RED_2, HIGH);
        // digitalWrite(BLUE_2, HIGH);
        // digitalWrite(RED_3, HIGH);
        // digitalWrite(BLUE_3, HIGH);
        // digitalWrite(RED_4, HIGH);
        // digitalWrite(BLUE_4, HIGH);

        // digitalWrite(RED_1, LOW);
        // digitalWrite(BLUE_1, LOW);
        // digitalWrite(RED_2, LOW);
        // digitalWrite(BLUE_2, LOW);
        // digitalWrite(RED_3, LOW);
        // digitalWrite(BLUE_3, LOW);
        // digitalWrite(RED_4, LOW);
        // digitalWrite(BLUE_4, LOW);
    }

    return 0;
}