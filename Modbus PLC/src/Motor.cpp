#include "Motor.h"

Motor::Motor() {
    stop();
}

void Motor::mode() {
    manAuto = !manAuto;
}

void Motor::start() {
    running = true;
}

void Motor::stop() {
    running = false;
}

void Motor::operate(int ctrlWord) {
    switch (ctrlWord)
    {
    case 32768:
        stop();
        mode();
        break;
    case 16384:
        start();
        break;
    case 8192:
        stop();
        break;
    }

    if (manAuto && !running)
    {
        status = 32768;
    } else if (!manAuto && running)
    {
        status = 16384;
    } else if (manAuto && running)
    {
        status = 49152;
    } else
    {
        status = 0;
    }
}