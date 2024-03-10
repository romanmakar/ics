#ifndef MOTOR_H
#define MOTOR_H

class Motor {
  public:
    bool manAuto;
    bool running;
    unsigned int status;
    Motor();
    void mode();
    void start();
    void stop();
    void operate(int ctrlWord);
};

#endif