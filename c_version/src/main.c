#include <wiringPi.h>

#define YELLOW_ONE 21
#define YELLOW_TWO 16
#define RED_ONE 23
#define RED_TWO 18
#define GREEN_ONE 13
#define GREEN_TWO 5
#define BLUE_ONE 22
#define BLUE_TWO 17
#define WHITE 12

int main(void) {
    wiringPiSetupGpio();

    pinMode(YELLOW_ONE, OUTPUT);
    pinMode(YELLOW_TWO, OUTPUT);

    pinMode(RED_ONE, OUTPUT);
    pinMode(RED_TWO, OUTPUT);

    pinMode(GREEN_ONE, OUTPUT);
    pinMode(GREEN_TWO, OUTPUT);

    pinMode(BLUE_ONE, OUTPUT);
    pinMode(BLUE_TWO, OUTPUT);

    pinMode(WHITE, OUTPUT);

    while (1) {
        digitalWrite(YELLOW_ONE, LOW);
        digitalWrite(YELLOW_TWO, LOW);

        digitalWrite(RED_ONE, LOW);
        digitalWrite(RED_TWO, LOW);

        digitalWrite(GREEN_ONE, LOW);
        digitalWrite(GREEN_TWO, LOW);

        digitalWrite(BLUE_ONE, LOW);
        digitalWrite(BLUE_TWO, LOW);

        digitalWrite(WHITE, HIGH);
    }

    return 0;
}