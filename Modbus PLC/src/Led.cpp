#include "Led.h"

Led::Led(int pin) {
    this->pin = pin;
    init();
}

void Led::init() {
    pinMode(pin, OUTPUT);
    off();
}

void Led::on() {
    digitalWrite(pin, HIGH);
}

void Led::off() {
    digitalWrite(pin, LOW);
}

void Led::blink(unsigned long blinkRate) {
    if (millis() > (currentMillis + blinkRate)) {
        currentMillis = millis();
        if (!state) {
            on();
            state = true;
        } else {
            off();
            state = false;
        }
    }
}