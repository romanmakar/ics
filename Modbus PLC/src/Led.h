#ifndef MY_LED_H
#define MY_LED_H

#include <Arduino.h>

class Led {

  private:
    int pin;
    unsigned long currentMillis;
    bool state;

  public:
    Led(int pin);
    void init();
    void on();
    void off();
    void blink(unsigned long blinkRate);
};

#endif